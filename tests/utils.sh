#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")
export PROJECT_ROOT

# Paths in which Ansible will search for Roles
ANSIBLE_ROLES_PATH=$(dirname "$PROJECT_ROOT")
export ANSIBLE_ROLES_PATH

syntax_check() {
    echo "*** Check syntax"
    if ansible-playbook tests/test.yml -i tests/inventory --syntax-check; then
        echo "Syntax check: pass"
    else
        echo "Syntax check: fail"
        return 1
    fi
}

run_tests() {
    local ansible_vars=("$@")
    local extra_vars
    extra_vars=$(printf ",%s" "${ansible_vars[@]}")
    extra_vars="{${extra_vars:1}}"

    echo "*** Run Ansible playbook"
    if run_playbook "${extra_vars}"; then
        echo "Playbook run: pass"
    else
        echo "Playbook run: fail"
        return 1
    fi

    echo "*** Idempotence test"
    if run_playbook "${extra_vars}" | grep -q 'changed=0.*failed=0'; then
        echo "Idempotence test: pass"
    else
        echo "Idempotence test: fail"
        return 1
    fi
}

run_playbook() {
    local extra_vars="$1"
    ansible-playbook tests/test.yml -i tests/inventory --connection=local \
        -e "${extra_vars}" -v
}

check_cloudsdk_version() {
    local cloudsdk_root="$1"
    local installed
    local expected

    installed=$(cloudsdk_version "${cloudsdk_root}")
    expected=$(defaults_gcloud_version)

    echo "*** Check Cloud SDK version"
    echo "Installed: ${installed}"
    echo "Expected: ${expected}"
    if [ "${installed}" != "${expected}" ]; then
        return 1
    fi
}

defaults_gcloud_version() {
    local defaults="${PROJECT_ROOT}/defaults/main.yml"
    local gcloud_version
    gcloud_version=$(grep "gcloud_version:" "${defaults}" | cut -d: -f2)
    gcloud_version=${gcloud_version//\"/}
    gcloud_version=${gcloud_version// /}
    echo "${gcloud_version}"
}

cloudsdk_version() {
    local cloudsdk_root="$1"
    if [ ! -e "${cloudsdk_root}/VERSION" ]; then
        return 1
    fi
    cat "${cloudsdk_root}/VERSION"
}

check_cloudsdk_path() {
    local cloudsdk_root="$1"

    echo "*** Cloud SDK should be installed in ${cloudsdk_root}"
    if [ -d "${cloudsdk_root}" ]; then
        echo "Found: ${cloudsdk_root}"
    else
        echo "Not found: ${cloudsdk_root}"
        return 1
    fi
}

check_gcloud_paths() {
    local gcloud_path="$1"

    echo "*** Cloud SDK should be on PATH in bash"
    gcloud_bash_path=$(bash -i -c 'command -v gcloud')
    echo "Expected: ${gcloud_path}"
    echo "Found: ${gcloud_bash_path}"
    if [ "${gcloud_bash_path}" != "${gcloud_path}" ]; then
        return 1
    fi

    echo "*** Cloud SDK should be on PATH in zsh"
    gcloud_zsh_path=$(zsh -i -c 'command -v gcloud')
    echo "Expected: ${gcloud_path}"
    echo "Found: ${gcloud_zsh_path}"
    if [ "${gcloud_zsh_path}" != "${gcloud_path}" ]; then
        return 1
    fi
}

check_gcloud_not_found() {
    echo "*** Cloud SDK should not be on PATH in bash"
    gcloud_bash_path=$(bash -i -c 'command -v gcloud')
    if [ "${gcloud_bash_path}" != "" ]; then
        echo "Unexpected binary found: ${gcloud_bash_path}"
        return 1
    fi

    echo "*** Cloud SDK should not be on PATH in zsh"
    gcloud_zsh_path=$(zsh -i -c 'command -v gcloud')
    if [ "${gcloud_zsh_path}" != "" ]; then
        echo "Unexpected binary found: ${gcloud_zsh_path}"
        return 1
    fi
}
