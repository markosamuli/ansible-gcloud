# Changelog

## [2.1.2] - 2019-11-23

### Changes

* Added `gcloud_prefer_python3` option for preferring `python3` over `python2`
  during install.

## [2.1.1] - 2019-11-20

### Documentation

* Updated documentation to include a fix into the configuration example
  and explain bash and zsh shell configuration.

### Development improvements

* Improved development bash scripts and coding style.
* Updated Docker images used for testing.

## [2.1.0] - 2019-11-19

### Changes

* Cloud SDK release 271.0.0
* Changed default installation path from `~/opt/google-cloud-sdk` to
  `~/google-cloud-sdk` with backwards compatible detection of the old
  default installation location
* Automatically added blocks in `.bashrc` and `.zshrc` do not look for other
  installation paths

### Development improvements

* Added `Makefile` with tasks for development
* Improved Travis CI performance with multiple build stages
* Added GitHub Actions workflow with pre-commit hooks for running linting tasks
  when new code is pushed to the repository
* Added [commitlint] commit-msg hook
* Fixed bash scripts not working on macOS with BSD sed
* Workaround for [ansible-lint installation issue][ansible-lint#590] on Travis
* Move bash scripts out of the repository root
* Format shell scripts with [shfmt]
* Validate shell scripts with [shellcheck]

[shfmt]: https://github.com/mvdan/sh
[shellcheck]: https://github.com/koalaman/shellcheck
[ansible-lint#590]: https://github.com/ansible/ansible-lint/issues/590
[commitlint]: https://github.com/conventional-changelog/commitlint

## [2.0.0] - 2019-06-22

## Breaking changes

Removed support for uploading Cloud SDK archive from the Ansible control
machine.

Do not install Cloud SDK from APT on Debian-based systems but use the
same archive install method as on macOS.

The APT install method is still included and can be enabled in the
configuration.

## Fixes

* Install [GNU tar] on macOS with Homebrew

[GNU tar]: https://formulae.brew.sh/formula/gnu-tar

## Compatibility

* Drop support and tests for Ansible below 2.6
* Do not test the role with macOS below 10.13

## [1.1.1] - 2019-03-02

* Use `include_tasks` instead deprecated `include`
* Drop support for testing the role with Ansible < 2.4

## [1.1.0] - 2019-03-02

* Updated Cloud SDK to version 236.0.0 on macOS.
* Fixed Google Cloud public key import on Debian.

## [1.0.0] - 2018-12-02

Initial release with Cloud SDK 226.0.0 on macOS.

This version installs Google Cloud SDK from from the archive file on macOS
and uses APT package manager for installing the SDK on Debian-based systems.

[1.1.1]: https://github.com/markosamuli/ansible-gcloud/releases/tag/v1.1.1
[1.1.0]: https://github.com/markosamuli/ansible-gcloud/releases/tag/v1.1.0
[1.0.0]: https://github.com/markosamuli/ansible-gcloud/releases/tag/v1.0.0
