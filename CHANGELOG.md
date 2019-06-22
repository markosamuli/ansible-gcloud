# Changelog

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
