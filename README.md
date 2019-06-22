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

## Update release

Run following script to update Cloud SDK version in Ansible variables:

```bash
./update-release
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
