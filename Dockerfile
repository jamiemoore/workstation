FROM centos:7
MAINTAINER Jamie Moore "jbgmoore@gmail.com"

RUN yum install -y openssh-clients
RUN yum install -y sudo
RUN yum install -y gcc
RUN echo "jamie    ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/jamie
RUN chmod 440 /etc/sudoers.d/jamie

RUN useradd jamie
USER jamie

WORKDIR /home/jamie/workstation-setup

CMD rm -f /home/jamie/.ssh/id_rsa; ssh-keygen -q -t rsa -f /home/jamie/.ssh/id_rsa -N ''; eval "$(ssh-agent -s)" > /dev/null ; ssh-add /home/jamie/.ssh/id_rsa > /dev/null 2>&1; /bin/bash
