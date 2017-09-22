#!/bin/bash
###############################################################################
# install.sh - quickly setup my development environment
###############################################################################


if test -z "$BASH_VERSION"; then
    echo "Please run this script using bash, not sh or any other shell." >&2
    exit 1
fi


# We wrap the entire script in a big function which we only call at the very end, in order to
# protect against the possibility of the connection dying mid-script. This protects us against
# the problem described in this blog post:
#   http://blog.existentialize.com/dont-pipe-to-your-shell.html
_() {

#Fail on failed commands
set -euo pipefail
IFS=$'\n\t'
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#Get Username
username=`whoami`

export PATH=~/bin:$PATH


check_ssh_agent() {

    #Check for entries in the ssh-agent
    if [[ ! `ssh-add -l | grep 256` ]]; then
        echo "Please the add your ssh key into the agent."
        exit 1
    fi

}

add_user_to_sudoers() {

    #Allow the current user to sudo without a password which is a more secure setting
    if [[ ! -f "/etc/sudoers.d/$username" ]]; then
        sudo sh -c 'echo "'"$username"'    ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/'"$username"
        sudo sh -c 'chmod 440 /etc/sudoers.d/'"$username"
    fi

}

install_software_using_sudo() {

    #Add EPEL
    sudo yum install -y epel-release

    #Install the standard development tools
    sudo yum groupinstall -y "Development tools"

    #Add tools
    sudo yum install -y tmux vim-enhanced xclip autojump keychain

    #Puppet Dev
    sudo yum install -y puppet rubygems
    sudo gem install puppet-lint

    #Python Dev
    sudo yum install -y python-pip python-devel
    sudo pip install --upgrade pip
    sudo pip install virtualenvwrapper

    #Ansible Dev
    sudo pip install ansible

}

create_projects_directory() {

    #Make the projects directory if it doesn't exist already
    if [[ ! -d $HOME/projects ]]; then
        mkdir $HOME/projects
    fi

}

create_bin_directory() {

    #Make the bin directory if it doesn't exist already
    if [[ ! -d $HOME/bin ]]; then
        mkdir $HOME/bin
    fi

}

configure_vim() {

    #Add github to known hosts
    set +e
    ssh -o StrictHostKeyChecking=no github.com
    set -e

    #Change to your home directory (Otherwise git clone will fail if running under sudo)
    cd ~

    #Install pathogen
    mkdir -p ~/.vim/autoload ~/.vim/bundle;
    curl -Lk -Ss -o ~/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

    #Vim Colourschemes
    if cd ~/.vim/bundle/vim-hybrid; then git pull; else git clone https://github.com/w0ng/vim-hybrid ~/.vim/bundle/vim-hybrid; fi
    if cd ~/.vim/bundle/jellybeans.vim; then git pull; else git clone https://github.com/nanotech/jellybeans.vim.git ~/.vim/bundle/jellybeans.vim; fi
    if cd ~/.vim/bundle/base16-vim; then git pull; else git clone https://github.com/chriskempson/base16-vim ~/.vim/bundle/base16-vim; fi

    #Vim Plugins 

    #Undo with tree structure (F5)
    if cd ~/.vim/bundle/gundo; then git pull; else git clone https://github.com/sjl/gundo.vim.git ~/.vim/bundle/gundo; fi
    #Autocomplete "snippets" (F2) start snip then press tab
    if cd ~/.vim/bundle/ultisnips; then git pull; else git clone https://github.com/SirVer/ultisnips ~/.vim/bundle/ultisnips; fi
    #My customised snippets
    if cd ~/.vim/UltiSnips; then git pull; else git clone  https://github.com/jamiemoore/UltiSnips.git ~/.vim/UltiSnips; fi
    #Syntax highlighting
    if cd ~/.vim/bundle/syntastic; then git pull; else git clone https://github.com/scrooloose/syntastic ~/.vim/bundle/syntastic; fi
    # Automatic closing of quotes, parenthesis, brackets, etc., 
    if cd ~/.vim/bundle/delimitMate; then git pull; else git clone https://github.com/Raimondi/delimitMate ~/.vim/bundle/delimitMate; fi
    # Automatically adds closing tags <HTML></HTML>
    if cd ~/.vim/bundle/closetag.vim; then git pull; else git clone https://github.com/docunext/closetag.vim ~/.vim/bundle/closetag.vim; fi
    #Change the " or ' around words with cs'" 
    if cd ~/.vim/bundle/vim-surround; then git pull; else git clone git://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround; fi
    # Fuzzy file browser (Ctrl-P)
    if cd ~/.vim/bundle/ctrlp; then git pull; else git clone https://github.com/kien/ctrlp.vim.git ~/.vim/bundle/ctrlp; fi
    #keyword completion system  
    if cd ~/.vim/bundle/neocomplcache.vim; then git pull; else git clone https://github.com/Shougo/neocomplcache.vim ~/.vim/bundle/neocomplcache.vim; fi
    #Ultrasnips compatibility with neocomlcache
    if cd ~/.vim/bundle/neocomplecache-ultisnips; then git pull; else git clone https://github.com/JazzCore/neocomplcache-ultisnips ~/.vim/bundle/neocomplecache-ultisnips; fi
    # Automatically align => with ,p 
    if cd ~/.vim/bundle/tabular; then git pull; else git clone https://github.com/godlygeek/tabular ~/.vim/bundle/tabular; fi
    #Using lightline instead of powerline because I don't want to install the font everywhere
    if cd ~/.vim/bundle/lightline.vim; then git pull; else git clone https://github.com/itchyny/lightline.vim ~/.vim/bundle/lightline.vim; fi
    # Puppet support
    if cd ~/.vim/bundle/vim-puppet; then git pull; else git clone https://github.com/rodjek/vim-puppet ~/.vim/bundle/vim-puppet; fi
    # pre-made snips in most languages
    if cd ~/.vim/bundle/vim-snippets; then git pull; else git clone https://github.com/honza/vim-snippets.git ~/.vim/bundle/vim-snippets; fi
    # NERDTree
    if cd ~/.vim/bundle/nerdtree; then git pull; else git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree; fi
    # .json syntax
    if cd ~/.vim/bundle/vim-json; then git pull; else git clone https://github.com/elzr/vim-json ~/.vim/bundle/vim-json; fi
    # match html tags
    if cd ~/.vim/bundle/MatchTag; then git pull; else git clone https://github.com/gregsexton/MatchTag ~/.vim/bundle/MatchTag; fi
    # match html tags
    if cd ~/.vim/bundle/vim-go; then git pull; else git clone https://github.com/fatih/vim-go ~/.vim/bundle/vim-go; fi
    #Ansible yml
    if cd ~/.vim/bundle/vim-ansible-yaml; then git pull; else git clone https://github.com/chase/vim-ansible-yaml.git ~/.vim/bundle/vim-ansible-yaml; fi

    #Javascript
    if cd ~/.vim/bundle/vim-javascript; then git pull; else git clone https://github.com/pangloss/vim-javascript.git ~/.vim/bundle/vim-javascript; fi

    #JSX
    if cd ~/.vim/bundle/vim-jsx; then git pull; else git clone https://github.com/mxw/vim-jsx.git  ~/.vim/bundle/vim-jsx; fi

    #Terraform
    if cd ~/.vim/bundle/vim-terraform; then git pull; else git clone https://github.com/hashivim/vim-terraform.git ~/.vim/bundle/vim-terraform; fi

}

dotfiles() {

    #Download and link dotfiles
    if cd ~/projects/dotfiles; then git pull; else git clone  https://github.com/jamiemoore/dotfiles.git ~/projects/dotfiles; fi
    ~/projects/dotfiles/join.sh

}

git_bash_prompt() {

    #bash git prompt
    if cd ~/.bash-git-prompt; then git pull; else git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt; fi

}

golang() {

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

}

check_docker() {

    if [[ `docker > /dev/null 2>&1` ]]; then
        echo "docker not found, please install"
        exit 1
    fi

}

install_git() {

    #Grab the docker file

    #install the wrapper.
    rm -f ~/bin/git
    curl https://raw.githubusercontent.com/jamiemoore/docker-devtools/master/git -o ~/bin/git > /dev/null 2>&1
    chmod +x ~/bin/git
}

install_tools_using_docker () {

    #Download and link dotfiles
    if cd ~/projects/docker-devools; then git pull; else git clone  https://github.com/jamiemoore/docker-devtools.git ~/projects/docker-devtools; fi
    ~/projects/docker-devtools/install.sh

}


check_ssh_agent
add_user_to_sudoers
check_docker
create_projects_directory
create_bin_directory
install_git
#install_software_using_sudo
install_tools_using_docker
#configure_vim
dotfiles
git_bash_prompt
#golang

# Now that we know the whole script has downloaded, run it.
}
_ "$0" "$@"

