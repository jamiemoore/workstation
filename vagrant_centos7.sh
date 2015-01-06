#!/bin/bash

#Install gnome
sudo yum group install -y "GNOME Desktop"

#Require lsb_release
sudo yum install -y redhat-lsb-core

#Create my user and add it to the vagrant group
sudo useradd jamie
usermod -a -G vagrant jamie

#Run the workstation setup script
sudo -u jamie /vagrant/setup

#Switch to runlevel 5
telinit 5
