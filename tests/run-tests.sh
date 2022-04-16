#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")

ROLE_NAME="$(basename "$PROJECT_ROOT")"
TEST_HOME=/home/test

if [[ $(uname -m) == arm64 ]]; then
    USE_BUILDKIT=${USE_BUILDKIT:-true}
else
    USE_BUILDKIT=${USE_BUILDKIT:-false}
fi

docker_run_opts=()

error() {
    echo "$@" 1>&2
}

setup_docker_opts() {
    if [ -z "$CI" ]; then
        docker_run_opts+=("-it")
    fi
}

detect_wsl() {
    is_wsl=0
    if [ -e /proc/version ]; then
        if grep -q Microsoft /proc/version; then
            echo "*** Windows Subsystem for Linux detected"
            is_wsl=1
        fi
    fi
}

finish() {
    local containers=""
    containers=$(docker ps -q --filter=name="${ROLE_NAME}")
    if [ -n "${containers}" ]; then
        echo "*** Stop all test containers"
        # shellcheck disable=SC2086
        docker stop ${containers}
    fi
}

stop() {
    local image=$1
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Stop containers"
    docker stop "${container_name}"
}

build() {
    local image=$1
    local image_name="${ROLE_NAME}-${image}"
    echo "*** Build image"
    docker build -t "${image_name}" "./tests/${image}"
}

build_using_buildkit() {
    local image=$1
    local platform=$2
    local image_name="${ROLE_NAME}-${image}"
    echo "*** Build image ${image} on platform ${platform}"
    docker buildx build \
        --platform "${platform}" \
        -t "${image_name}" \
        "./tests/${image}"
}

start() {
    local image=$1
    local platform=$2
    local image_name="${ROLE_NAME}-${image}"
    local container_name="${ROLE_NAME}-${image}-tests"
    local start_opts=()
    if [ -n "${platform}" ]; then
        start_opts+=("--platform")
        start_opts+=("${platform}")
    fi
    echo "*** Start container"
    docker run --rm -d \
        "${docker_run_opts[@]}" \
        "${start_opts[@]}" \
        -v "${MOUNT_ROOT}:${TEST_HOME}/${ROLE_NAME}" \
        --name "${container_name}" \
        "${image_name}"
}

run_tests() {
    local image=$1
    local platform=$2
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
        start "${image}" "$platform"
        run_test_script "${image}" "${test_script}"
        stop "${image}"
        # Give Docker time to clean up
        sleep 1
    done
}

run_test_script() {
    local image=$1
    local test_script=$2
    local container_name="${ROLE_NAME}-${image}-tests"
    echo "*** Run tests with ${test_script} in ${image}"
    docker exec \
        "${docker_run_opts[@]}" \
        --user test \
        "${container_name}" \
        "${TEST_HOME}/${ROLE_NAME}/tests/${test_script}"
}

if ! command -v docker >/dev/null; then
    error "docker not found"
    exit 1
fi

trap finish EXIT

detect_wsl

setup_docker_opts

cd "${TESTS_DIR}"

images=("$@")
if [ ${#images[@]} -eq 0 ]; then
    images=(*/Dockerfile)
    images=("${images[@]/\/Dockerfile/}")
fi

platforms=(
    "linux/amd64"
)

cd "$PROJECT_ROOT"

if [ "${is_wsl}" == "1" ]; then
    MOUNT_ROOT="$(pwd -P | sed 's~/mnt/c/~c:/~')"
else
    MOUNT_ROOT="$(pwd -P)"
fi

set -e

for i in "${images[@]}"; do
    if [ "${USE_BUILDKIT}" == "true" ]; then
        for p in "${platforms[@]}"; do
            build_using_buildkit "$i" "$p" || {
                error "failed to build $i for platform $p"
                exit 1
            }
        done
    else
        build "$i" || {
            error "failed to build $i"
            exit 1
        }
    fi
done

for i in "${images[@]}"; do
    if [ "${USE_BUILDKIT}" == "true" ]; then
        for p in "${platforms[@]}"; do
            run_tests "$i" "$p" || {
                error "failed tests $i on platform $p"
                exit 1
            }
        done
    else
        run_tests "$i" || {
            error "failed tests in $i"
            exit 1
        }
    fi
done
