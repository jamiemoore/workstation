#!/bin/bash


#
#
#

function isamac {
    if [ -d "/users" ]; then
      return 0
    fi
      return 1
}


exit



quit


###############################################################################
# Configure my Workstation - Headless
###############################################################################

#if isamac ; then

#Readlink on a mac
brew install coreutils

alias readlink=greadlink

#else

#Install LSB if on CentOS
#sudo yum install -y redhat-lsb-core

#Detect OS
#os=`lsb_release -is`
#minor_version=`lsb_release -rs`
#version=`echo $minor_version | cut -f1 -d '.'`

#fi

#Where are we run from
_script="$(greadlink -f ${BASH_SOURCE[0]})"
current_dir="$(dirname $_script)"

#exit

#Get Username
username=`whoami`

#Change to your home directory (Otherwise git clone will fail if running under sudo)
cd ~

#Check for private key
if [[ ! -f ~/.ssh/id_rsa ]]; then
    echo "Please copy id_rsa into the .ssh directory."
    exit 1
fi
#Check for public key
if [[ ! -f ~/.ssh/id_rsa.pub ]]; then
    echo "Please copy id_rsa.pub into .ssh directory."
    exit 1
fi


#Allow the current user to sudo without a password
sudo sh -c 'echo "'"$username"'    ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/'"$username"
sudo sh -c 'chmod 440 /etc/sudoers.d/'"$username"

#Check if sudo is working 
#if [[ $? -ne 0 ]]; then
#    echo "Failed to configure sudoers."
#    exit 2
#fi

#Add github to known hosts
ssh -o StrictHostKeyChecking=no github.com

#Configure private and public ssh key 
if [[ ! -f ~/.ssh/id_rsa ]]; then
    echo "Private key does not exist in .$username/.ssh/, adding."
    cp -p $current_dir/id_rsa ~/.ssh/id_rsa
    cp -p $current_dir/id_rsa.pub ~/.ssh/id_rsa.pub
    chmod 600 ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa.pub
fi

#Add public key to authorized keys file
if [[ ! -f ~/.ssh/authorized_keys ]]; then
    echo "Adding public key to authorized keys."
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

#Install packages depending on distro
if [ "$os" == 'CentOS' ] && [ "$version" == '7' ]; then

    #Add EPEL
    sudo yum install -y epel-release

    #Add tools
    sudo yum install -y tmux git curl vim-enhanced xclip autojump keychain mosh

    #Puppet Dev
    sudo yum install -y puppet rubygems
    sudo gem install puppet-lint

    #Python Dev
    sudo yum install -y python-pip python-devel
    sudo pip install --upgrade pip
    sudo pip install virtualenvwrapper

    #Ansible Dev
    sudo pip install ansible


elif [ "$os" == 'Debian' ]  && [ "$version" == '7' ]; then
    #Update
    sudo apt-get update
    #Install pre-requisits
    sudo apt-get install -y tmux git curl vim-nox keychain autojump xclip
    #Debian package does not automatically load autojump
    if [[ ! -f /etc/profile.d/autojump.sh ]]; then
        sudo cp /usr/share/autojump/autojump.sh /etc/profile.d/
    fi

    #Puppet Dev
    sudo apt-get install -y puppet-common rubygems
    sudo gem install puppet-lint

    #Python Dev
    sudo apt-get install -y python-pip python-dev
    sudo pip install virtualenvwrapper


else
    echo "Unknown OS, check lsb_release -is"
#    exit 1
fi

#Download and link dotfiles
if cd ~/projects/dotfiles; then git pull; else git clone  https://github.com/jamiemoore/dotfiles.git ~/projects/dotfiles; fi
~/projects/dotfiles/join

#Make the projects directory
if [[ ! -d $HOME/projects ]]; then
    mkdir $HOME/projects
fi

#bash git prompt
if cd ~/.bash-git-prompt; then git pull; else git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt; fi

#Go development

#TODO: Install Go

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
GOGITHUB=$GOPATH/src/github.com/jamiemoore

if [[ ! -d $GOPATH ]]; then
    mkdir $GOPATH
fi

if [[ ! -d $GOGITHUB ]]; then
    mkdir -p $GOGITHUB
fi

go get github.com/tools/godep

#Source your new dot files so you are good to go, no need to do this when called by sudo
if [[ -z "$SUDO_COMMAND" ]]; then
    . ~/.bashrc
    . /etc/profile.d/autojump.sh
fi
