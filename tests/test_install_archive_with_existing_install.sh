#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_install_archive_in_home_opt() {
    local gcloud_install_dir="/opt"
    local cloudsdk_root="${HOME}/opt/google-cloud-sdk"
    local gcloud_path="${cloudsdk_root}/bin/gcloud"

    local ansible_vars=()
    ansible_vars+=("'gcloud_install_from_package_manager':false")
    ansible_vars+=("'gcloud_install_dir':'${gcloud_install_dir}'")

    run_tests "${ansible_vars[@]}" || exit 1

    check_cloudsdk_path "${cloudsdk_root}" || exit 1
    check_gcloud_paths "${gcloud_path}" || exit 1
}

test_install_archive_with_existing_install() {
    local cloudsdk_root="${HOME}/opt/google-cloud-sdk"
    local gcloud_path="${cloudsdk_root}/bin/gcloud"

    local ansible_vars=()
    ansible_vars+=("'gcloud_install_from_package_manager':false")

    run_tests "${ansible_vars[@]}" || exit 1

    check_cloudsdk_path "${cloudsdk_root}" || exit 1
    check_gcloud_paths "${gcloud_path}" || exit 1
}

cd "${PROJECT_ROOT}"

set -e

# Install into ~/opt/google-cloud-sdk
test_install_archive_in_home_opt

# Detect existing install in ~/opt/google-cloud-sdk
test_install_archive_with_existing_install
