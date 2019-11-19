#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT=$(dirname "$DIR")

ROLE_NAME="$(basename "$PROJECT_ROOT")"
TEST_HOME=/home/test

# Detect Windows Subsystem for Linux
function detect_wsl {
    is_wsl=0
    if [ -e /proc/version ]; then
        if grep -q Microsoft /proc/version; then
            echo "*** Windows Subsystem for Linux detected"
            is_wsl=1
        fi
    fi
}

# Stop all containers
function finish {
    local containers=""
    # shellcheck disable=SC2086
    containers=$(docker ps -q --filter=name=${ROLE_NAME})
    if [ -n "${containers}" ]; then
        echo "*** Stop all test containers"
        # shellcheck disable=SC2086
        docker stop ${containers}
    fi
}

# Stop container
function stop {
    local image=$1
    local container_name=${ROLE_NAME}-${image}-tests
    echo "*** Stop containers"
    docker stop "${container_name}"
}

# Build image
function build {
    local image=$1
    local image_name=${ROLE_NAME}-${image}
    echo "*** Build image"
    docker build -t "${image_name}" "./tests/${image}"
}

# Start container in the background
function start {
    local image=$1
    local image_name=${ROLE_NAME}-${image}
    local container_name=${ROLE_NAME}-${image}-tests
    echo "*** Start container"
    docker run --rm -it -d \
        -v "${MOUNT_ROOT}:${TEST_HOME}/${ROLE_NAME}" \
        --name "${container_name}" \
        "$image_name"
}
# Run tests in the container
function run_tests {
    local image=$1
    local test_scripts=(
        "test_syntax.sh"
        "test_install_archive.sh"
        "test_install_archive_in_home_opt.sh"
        "test_install_archive_in_custom_path.sh"
        "test_install_archive_no_shell_init.sh"
        "test_install_archive_with_existing_install.sh"
        "test_install_apt.sh"
        "test_install_archive_with_existing_apt.sh"
    )
    for test_script in "${test_scripts[@]}"; do
        start "${image}"
        run_test_script "${image}" "${test_script}"
        stop "${image}"
        # Give Docker time to clean up
        sleep 1
    done
}

# Run tests in the container
function run_test_script {
    local image=$1
    local test_script=$2
    local container_name=${ROLE_NAME}-${image}-tests
    echo "*** Run tests with ${test_script} in ${image}"
    docker exec -it \
        --user test \
        "${container_name}" \
        "${TEST_HOME}/${ROLE_NAME}/tests/${test_script}"
}

trap finish EXIT

detect_wsl

cd "$DIR"

images=( "$@" )
if [ ${#images[@]} -eq 0 ]; then
    images=( */Dockerfile )
    images=( "${images[@]/\/Dockerfile/}" )
fi

cd "$PROJECT_ROOT"

if [ "${is_wsl}" == "1" ]; then
    MOUNT_ROOT="$(pwd -P | sed 's~/mnt/c/~c:/~')"
else
    MOUNT_ROOT="$(pwd -P)"
fi

set -e

for i in "${images[@]}"; do
    build "$i"
done

for i in "${images[@]}"; do
    run_tests "$i"
done