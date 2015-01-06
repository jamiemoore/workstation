#!/bin/bash
#sudo yum group install -y "GNOME Desktop"
sudo yum install -y redhat-lsb-core

sudo useradd jamie
echo "jamie    ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/admins
chmod 440 /etc/sudoers.d/admins

sudo -u jamie /vagrant/setup

#sudo -u jamie ./setup.sh
#./setup
#telinit 3
