# workstation

Quickly configure my workstation developer environment.

## Environments

- Mac OSX
- Debian WSL

## Requirements

- Homebrew

- (on Mac) xcode cli

  ```
  xcode-select --install
  ```

- Ansible

  ```
  brew install ansible
  ```

## Execution

- Download using git

  ```
  git clone git@github.com:jamiemoore/workstation.git
  ```

- Move the current `.zshrc` (GNU Stow will not overwrite by design)

  ```
  mv ~/.zshrc ~/.zshrc.old
  ```

- Run ansible

  ```
  ansible-playbook -K playbook.yml
  ```
