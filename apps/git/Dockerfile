FROM centos:7
MAINTAINER Jamie Moore "jbgmoore@gmail.com"

RUN yum install -y openssh-clients
RUN yum install -y sudo
RUN yum install -y gcc
RUN yum install -y make openssl-devel curl-devel expat-devel perl perl-devel gettext
RUN mkdir /app

RUN echo "jamie    ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/jamie
RUN chmod 440 /etc/sudoers.d/jamie

RUN cd /app ; curl -LO https://github.com/git/git/archive/v2.14.1.tar.gz
RUN cd /app ; tar -zxvf v2.14.1.tar.gz 
RUN cd /app/git-2.14.1/ ; make prefix=/usr/local 
RUN cd /app/git-2.14.1/ ; make prefix=/usr/local install

RUN useradd jamie
#RUN chown jamie /app
USER jamie

COPY entrypoint.sh /entrypoint.sh

WORKDIR /home/jamie

ENTRYPOINT ["/entrypoint.sh"]
