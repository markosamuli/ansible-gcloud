#!/usr/bin/env bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$SCRIPTS_DIR")

###
# Print error into STDERR
###
error() {
    echo "$@" 1>&2
}

###
# Get latest release Google Cloud SDK relaase
###
latest_cloud_sdk_release() {
    local os=$1
    local arch=$2
    local bucket="cloud-sdk-release"
    local prefix="google-cloud-sdk-"

    [ -z "${os}" ] && {
        error "OS missing"
        return 1
    }
    [ -z "${arch}" ] && {
        error "architecture missing"
        return 1
    }

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

###
# Update version
###
update_default_version() {
    local release=$1
    update_ansible_defaults "${release}"
}

###
# Update version
###
update_os_version() {
    local os=$1
    local release=$2
    update_ansible_vars "${os}" "${release}"
}

###
# Update version variable in Ansible defaults
###
update_ansible_defaults() {
    local version=$1

    [ -z "${version}" ] && {
        error "Version missing"
        return 1
    }

    local defaults_file=defaults/main.yml

    # Update variables
    echo "Updating variables in ${defaults_file}"
    if test "$(uname)" = "Darwin"; then
        sed -i.save -E "s/^(gcloud_version):.*$/\1: \"${version}\"/" \
            "${defaults_file}"
    else
        sed -i.save -r "s/^(gcloud_version):.*$/\1: \"${version}\"/" \
            "${defaults_file}"
    fi
    rm "${defaults_file}.save"
}

###
# Update version variable in OS variables
###
update_ansible_vars() {
    local os=$1
    local version=$2

    [ -z "${version}" ] && {
        error "Version missing"
        return 1
    }

    # Ansible vars file to update
    local ansible_os=""
    if [ "${os}" == "darwin" ] || [ "${os}" == "Darwin" ]; then
        ansible_os="Darwin"
    elif [ "${os}" == "debian" ] || [ "${os}" == "Debian" ]; then
        ansible_os="Debian"
    fi
    [ -z "${ansible_os}" ] && {
        error "Unsupported OS: ${os}"
        return 1
    }

    local vars_file=vars/os/${ansible_os}.yml

    # Update variables
    echo "Updating variables in ${vars_file}"
    if test "$(uname)" = "Darwin"; then
        sed -i.save -E "s/^(gcloud_version):.*$/\1: \"${version}\"/" \
            ${vars_file}
    else
        sed -i.save -r "s/^(gcloud_version):.*$/\1: \"${version}\"/" \
            ${vars_file}
    fi
    rm ${vars_file}.save
}

###
# Update versions
###
update_versions() {
    local cloudsdk_version
    cloudsdk_version=$(latest_cloud_sdk_release linux x86_64)
    echo "Latest Google Cloud SDK release is ${cloudsdk_version}"
    update_default_version "${cloudsdk_version}"
    update_os_version Debian "${cloudsdk_version}"
    update_os_version Darwin "${cloudsdk_version}"
}

set -e

cd "${PROJECT_ROOT}"

update_versions