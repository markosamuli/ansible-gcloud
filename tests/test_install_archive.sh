#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=tests/utils.sh
source "${TESTS_DIR}/utils.sh"

test_install_archive() {
    local cloudsdk_root="${HOME}/google-cloud-sdk"
    local gcloud_path="${cloudsdk_root}/bin/gcloud"

    local ansible_vars=()
    ansible_vars+=("'gcloud_install_from_package_manager':false")

    run_tests "${ansible_vars[@]}" || exit 1

    check_cloudsdk_path "${cloudsdk_root}" || exit 1
    check_cloudsdk_version "${cloudsdk_root}" || exit 1
    check_gcloud_paths "${gcloud_path}" || exit 1
}

cd "${PROJECT_ROOT}"

set -e

# Install with defaults into ~/google-cloud-sdk
test_install_archive
