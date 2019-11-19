#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$SCRIPTS_DIR")

# shellcheck source=scripts/utils.sh
source "${SCRIPTS_DIR}/utils.sh"

# Get latest release Google Cloud SDK relaase
latest_cloud_sdk_release() {
    local os=$1
    local arch=$2
    local bucket="cloud-sdk-release"
    local prefix="google-cloud-sdk-"

    if [ -z "${os}" ]; then
        error "OS missing"
        return 1
    fi
    if [ -z "${arch}" ]; then
        error "architecture missing"
        return 1
    fi

    os=$(echo "${os}" | awk '{print tolower($0)}')
    if [ "${os}" == "darwin" ] || [ "${os}" == "linux" ]; then
        local suffix="-${os}-${arch}.tar.gz"
    else
        error "Unsupported OS: ${os}"
        return 1
    fi

    gsutil ls "gs://${bucket}/${prefix}*${suffix}" |
        sed "s/gs:\/\/${bucket}\/${prefix}//g" |
        sed "s/${suffix}//g" |
        sort -nr | head -1
}

# Update version
update_default_version() {
    local version=$1
    if [ -z "${version}" ]; then
        error "Version missing"
        return 1
    fi
    update_default_variable "gcloud_version" "${version}"
}

# Update version
update_os_version() {
    local os=$1
    local version=$2
    if [ -z "${os}" ]; then
        error "OS name missing"
        return 1
    fi
    if [ -z "${version}" ]; then
        error "Version missing"
        return 1
    fi
    update_os_variable "${os}" "gcloud_version" "${version}"
}

# Update versions
update_versions() {
    local cloudsdk_version
    cloudsdk_version=$(latest_cloud_sdk_release linux x86_64)
    echo "Latest Google Cloud SDK release is ${cloudsdk_version}"
    update_default_version "${cloudsdk_version}"
    update_os_version Debian "${cloudsdk_version}"
    update_os_version Darwin "${cloudsdk_version}"
}

# Check gsutil is installed
check_gsutil() {
    command -v gsutil >/dev/null || {
        error "gsutil is not installed"
        exit 1
    }
}

set -e

cd "${PROJECT_ROOT}"

check_gsutil
update_versions
