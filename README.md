workstation-setup
=================

Bash script used to configure my workstation

* Installs tools
* Installs my required development environments
* Configures Vim
* Installs my dotfiles repository

## Requirements

* Configure the hostname
* Configure the search domain
* Create a user account
* Public and Private ssh keys placed in .ssh
* Currently CentOS 7 only

## Installation 

```bash
cd ~
mkdir projects
cd projects
git clone https://github.com/jamiemoore/workstation-setup.git
cd workstation-setup
./setup
```
