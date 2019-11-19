#!/usr/bin/env bash

TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=$(dirname "$TESTS_DIR")
ROLE_NAME="$(basename "$PROJECT_ROOT")"

update_dockerfile() {
    local image=$1
    local release=$2
    echo "*** Updating $release/Dockerfile"
    if test "$(uname)" = "Darwin"; then
        sed -E \
            -e 's!%%FROM%%!'"$image:$release"'!g' \
            -e 's!%%USER%%!'"$user"'!g' \
            -e 's!%%REPOSITORY%%!'"$repository"'!g' \
            -e 's!%%ANSIBLE_VERSION%%!'"$ansible_version"'!g' \
            "Dockerfile.template" >"$release/Dockerfile"
    else
        sed -r \
            -e 's!%%FROM%%!'"$image:$release"'!g' \
            -e 's!%%USER%%!'"$user"'!g' \
            -e 's!%%REPOSITORY%%!'"$repository"'!g' \
            -e 's!%%ANSIBLE_VERSION%%!'"$ansible_version"'!g' \
            "Dockerfile.template" >"$release/Dockerfile"
    fi
}

set -euo pipefail

cd "${TESTS_DIR}"

user="test"
repository="${ROLE_NAME}"
ansible_version="<2.9.0"

image="ubuntu"
ubuntu_releases=(xenial bionic)
for release in "${ubuntu_releases[@]}"; do
    update_dockerfile "${image}" "${release}"
done

image="debian"
debian_releases=(stretch buster)
for release in "${debian_releases[@]}"; do
    update_dockerfile "${image}" "${release}"
done
