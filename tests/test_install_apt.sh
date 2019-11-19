#!/usr/bin/env bash

TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_install_apt() {
    local cloudsdk_root="/usr/share/google-cloud-sdk"
    local gcloud_path="/usr/bin/gcloud"

    local ansible_vars=()
    ansible_vars+=("'gcloud_install_from_package_manager':true")

    run_tests "${ansible_vars[@]}" || exit 1

    check_cloudsdk_path "${cloudsdk_root}" || exit 1
    check_cloudsdk_version "${cloudsdk_root}" || exit 1
    check_gcloud_paths "${gcloud_path}" || exit 1
}

cd "${PROJECT_ROOT}"

set -e

# Install with APT package manager
test_install_apt
