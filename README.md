# Install Google Cloud SDK

[![GitHub release](https://img.shields.io/github/release/markosamuli/ansible-gcloud.svg)](https://github.com/markosamuli/ansible-gcloud/releases)
[![License](https://img.shields.io/github/license/markosamuli/ansible-gcloud.svg)](https://github.com/markosamuli/ansible-gcloud/blob/master/LICENSE)

| Branch  | Status |
|---------|--------|
| master  | [![Build Status](https://travis-ci.org/markosamuli/ansible-gcloud.svg?branch=master)](https://travis-ci.org/markosamuli/ansible-gcloud)
| develop | [![Build Status](https://travis-ci.org/markosamuli/ansible-gcloud.svg?branch=develop)](https://travis-ci.org/markosamuli/ansible-gcloud)

This Ansible role to install Google Cloud SDK on Ubuntu and macOS development
machines.

Do not use this on production servers.

## Configuration

### Installation location

The role installs Cloud SDK by default into `~/google-cloud-sdk`.

To install to another location, change the `gcloud_install_dir` variable. It
will be used as the installation directory relative to the user home directory.

For example to install into `~/opt/google-cloud-sdk`, you can set:

```yaml
gcloud_install_dir: "opt"
```

For backwards compatibility, the role will automatically detect existing
installation in `~/opt/google-cloud-sdk` and default to this location
if found.

### Install using package manager

To install Cloud SDK from the package manager where available, enable it in
Ansible configuration:

```yaml
gcloud_install_from_package_manager: true
```

This is only supported on Debian-based systems with APT repositories.

## Update release

Update Cloud SDK version in Ansible variables:

```bash
make update
```

## Coding style

Install pre-commit hooks and validate coding style:

```bash
make lint
```

## Run tests

Run tests in Ubuntu and Debian using Docker:

```bash
make test
```

## License

- [MIT](LICENSE)

## Contributions

Installation script is based on [ansible/role-install-gcloud] Ansible role
by [@chouseknecht].

[ansible/role-install-gcloud]: https://github.com/ansible/role-install-gcloud
[@chouseknecht]: https://github.com/chouseknecht

## Authors

- [@markosamuli](https://github.com/markosamuli)
