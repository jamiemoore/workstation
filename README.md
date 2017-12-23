dev-environment
=================

Quickly configure my developer environment.



## Requirements

* Only Supports Centos7

* Requires ssh keys to be loaded into an agent

* Requires gcc

  ​


## Installation

* Install using curl

  ```bash
  curl https://install.jamie.so | bash

  or

  curl https://raw.githubusercontent.com/jamiemoore/workstation-setup/master/install.sh | bash
  ```

  ​


## Development in dockerfile


* Build the dockerfile

  ```bash
  docker build -t "jamie/ws-setup" .
  ```


* Run the docker file

  ```bash
  docker run -it -h "dockerws" -v ${PWD}:/home/jamie/workstation-setup jamie/ws-setup
  ```
