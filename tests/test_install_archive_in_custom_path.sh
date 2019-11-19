#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_install_archive_in_custom_install_path() {
    local gcloud_install_path="${HOME}/tools"
    local cloudsdk_root="${HOME}/tools/google-cloud-sdk"
    local gcloud_path="${cloudsdk_root}/bin/gcloud"

    local ansible_vars=()
    ansible_vars+=("'gcloud_install_from_package_manager':false")
    ansible_vars+=("'gcloud_install_path':'${gcloud_install_path}'")

    run_tests "${ansible_vars[@]}" || exit 1

    check_cloudsdk_path "${cloudsdk_root}" || exit 1
    check_cloudsdk_version "${cloudsdk_root}" || exit 1
    check_gcloud_paths "${gcloud_path}" || exit 1
}

cd "${PROJECT_ROOT}"

set -e

# Install into ~/tools/google-cloud-sdk
test_install_archive_in_custom_install_path
