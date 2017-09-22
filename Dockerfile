FROM centos:7
MAINTAINER Jamie Moore "jbgmoore@gmail.com"

RUN yum install -y openssh-clients
RUN yum install -y sudo
RUN yum install -y gcc

#Install Docker
RUN yum install -y yum-utils device-mapper-persistent-data lvm2
RUN yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
RUN yum install -y docker-ce

#Setup Sudo
RUN echo "jamie    ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/jamie
RUN chmod 440 /etc/sudoers.d/jamie

RUN useradd jamie
RUN usermod -G docker jamie
USER jamie

WORKDIR /home/jamie/workstation-setup

CMD rm -f /home/jamie/.ssh/id_rsa; ssh-keygen -q -t rsa -f /home/jamie/.ssh/id_rsa -N ''; eval "$(ssh-agent -s)" > /dev/null ; ssh-add /home/jamie/.ssh/id_rsa > /dev/null 2>&1; /bin/bash
