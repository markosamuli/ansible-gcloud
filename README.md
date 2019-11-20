# Install Google Cloud SDK

[![Ansible Quality Score](https://img.shields.io/ansible/quality/41433.svg)](https://galaxy.ansible.com/markosamuli/gcloud)
[![Ansible Role](https://img.shields.io/ansible/role/41433.svg)](https://galaxy.ansible.com/markosamuli/gcloud)
[![GitHub release](https://img.shields.io/github/release/markosamuli/ansible-gcloud.svg)](https://github.com/markosamuli/ansible-gcloud/releases)
[![License](https://img.shields.io/github/license/markosamuli/ansible-gcloud.svg)](https://github.com/markosamuli/ansible-gcloud/blob/master/LICENSE)

| Branch  | Travis Builds | Code Quality |
|---------|--------|--------------|
| master  | [![Build Status][travis-master]][travis] | ![Build Status][gh-master] |
| develop | [![Build Status][travis-develop]][travis] | ![Build Status][gh-develop] |

[travis]: https://travis-ci.org/markosamuli/ansible-gcloud/branches
[travis-master]: https://travis-ci.org/markosamuli/ansible-gcloud.svg?branch=master
[travis-develop]: https://travis-ci.org/markosamuli/ansible-gcloud.svg?branch=develop
[gh-master]: https://github.com/markosamuli/ansible-gcloud/workflows/Code%20Quality/badge.svg?branch=master
[gh-develop]: https://github.com/markosamuli/ansible-gcloud/workflows/Code%20Quality/badge.svg?branch=develop

This Ansible role to install Google Cloud SDK on Ubuntu and macOS development
machines.

Do not use this on production servers.

## Installation location

The role installs Cloud SDK by default into `~/google-cloud-sdk`.

To install to another location, change the `gcloud_install_dir` variable. It
will be used as the installation directory relative to the user home directory.

For example to install into `~/opt/google-cloud-sdk`, you can set:

```yaml
# Install to ~/opt/google-cloud-sdk
gcloud_install_dir: "/opt"
```

For backwards compatibility, the role will automatically detect existing
installation in `~/opt/google-cloud-sdk` and default to this location
if found.

## Install using package manager

To install Cloud SDK from the package manager where available, enable it in
Ansible configuration:

```yaml
# Install Cloud SDK from APT
gcloud_install_from_package_manager: true
```

This is only supported on Debian-based systems with APT repositories.

## Changes to shell config files

This role makes changes to the `.bashrc` and `.zshrc` files if these exist in
your home directory. It will resolve any symbolic links to your dotfiles
when making changes.

Code completion for `gcloud` command is loaded with all installation options.

If you're managing your shell scripts `.dotfiles` or are using a framework, you
should set `gcloud_setup_shell` to `false` and update these files yourself to
keep them clean.

```yaml
# Do not mess with my dotfiles!
gcloud_setup_shell: false
```

### Configuring bash manually

Reference `.bashrc` configuration when installed into
`~/google-cloud-sdk` using the archive:

```bash
if [ -d "$HOME/google-cloud-sdk" ]; then
  export CLOUDSDK_ROOT_DIR="$HOME/google-cloud-sdk"
  # Update PATH for the Google Cloud SDK.
  source $CLOUDSDK_ROOT_DIR/path.bash.inc
  # Enable bash completion for gcloud.
  source $CLOUDSDK_ROOT_DIR/completion.bash.inc
fi
```

If your `.bashrc` already has a `export CLOUDSDK_ROOT_DIR=` line, the file
will not be modified.

Reference `.bashrc` configuration when installed from APT:

```zsh
if [ -d "/usr/share/google-cloud-sdk" ]; then
  # Enable zsh completion for gcloud.
  source /usr/share/google-cloud-sdk/completion.bash.inc
fi
```

### Configuring zsh manually

Reference `.zshrc` configuration when installed into
`~/google-cloud-sdk` using the archive:

```zsh
if [ -d "$HOME/google-cloud-sdk" ]; then
  export CLOUDSDK_ROOT_DIR="$HOME/google-cloud-sdk"
  # Update PATH for the Google Cloud SDK.
  source $CLOUDSDK_ROOT_DIR/path.zsh.inc
  # Enable zsh completion for gcloud.
  source $CLOUDSDK_ROOT_DIR/completion.zsh.inc
fi
```

If your `.zshrc` already has a `export CLOUDSDK_ROOT_DIR=` line, the file
will not be modified.

Reference `.zshrc` configuration when installed from APT:

```zsh
if [ -d "/usr/share/google-cloud-sdk" ]; then
  # Enable zsh completion for gcloud.
  source /usr/share/google-cloud-sdk/completion.zsh.inc
fi
```

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
