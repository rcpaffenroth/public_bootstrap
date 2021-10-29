#! /bin/bash

# This can be gotten using
#
#  wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/RUNME.sh 
#  
#  or
#
#  wget bit.ly/rcp_run_me
#
#  To get started from a really clean system
#
#  apt-get update && apt-get install wget && wget bit.ly/rcp_run_me && bash ./rcp_run_me

#  apt-get update && apt-get install -y wget && wget https://bitbucket.org/rcpaffenroth/ansible/raw/HEAD/bin/RUNME.sh && bash ./RUNME.sh


# This is a subtle order dependence here.  I would like to run as much as possible
# through ansible.  However, that means I need access to the ansible repository,
# which is *private*.   So, I need my ssh keys to access that private repository.  
# However, to get those keys I need git and openssh.  
# 
# Accordingly, the order here is:
#  Install prerequites of git and openssh.  We do ansible while we are at it.
#  Get my ssh keys.
#  Get the ansible repository.
#  Everything else is in ansible.
#
# Perhaps a better way is to install just ansible, do an ansible pull, and they do
# the rest.  In particular, using ansible to install ssh keys *remotely* is very
# scary, since if the keys are ever inconsistent you can loose access!  However,
# perhaps it is not so scary if it is only done locally.

umask 022

function install_prerequisites() {
    if hash git 2>/dev/null; then
        echo "Using existing git"
    else
        apt update
        apt install -y git
    fi

    if hash ssh 2>/dev/null; then
        echo "Using existing ssh"
    else
        apt update
        apt install -y openssh-client
    fi

    if hash ansible 2>/dev/null; then
        echo "Using existing ansible"
    else
        apt update
        apt install -y software-properties-common
        # To get the newest version
        apt-add-repository --yes --update ppa:ansible/ansible
        apt install -y ansible 
    fi
}

function get_ssh_keys() {
    # Setup ssh to not care about key checking
    export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

    # Get my ssh keys
    if [ -f "$HOME/.ssh/id_rsa" ]; then
        echo "Using existing .ssh"
    else
        rm -rf $HOME/.ssh.bak $HOME/ssh 
        git clone rcpaffenroth@haven.rcpaffenroth.org:repos/ssh.git $HOME/ssh
        mv $HOME/.ssh $HOME/.ssh.bak
        mv $HOME/ssh $HOME/.ssh
        sh $HOME/.ssh/permissions.sh
        eval `ssh-agent`
        ssh-add $HOME/.ssh/id_rsa
    fi
}

function checkout_ansible_repository() {
    # Get ansible repository, since that is where the ansible playbooks are
    if [ -d "$HOME/projects/ansible" ]; then
        echo "Using existing projects/ansible"
    else
        mkdir -p $HOME/projects
        git clone git@bitbucket.org:rcpaffenroth/ansible $HOME/projects/ansible
    fi
}

function ansible_system_setup() {
    cd $HOME/projects/ansible
    ansible-playbook -i inventory/localhost.ini playdir/system_setup.yml
}

function ansible_rcpaffenroth_setup() {
    cd $HOME/projects/ansible
    ansible-playbook -i inventory/localhost.ini playdir/rcpaffenroth_setup.yml
}

if [ "$EUID" -eq 0 ]; then 
    echo "running as root"    
else
    echo "*not* running as root"
fi

if [ "$EUID" -eq 0 ]; then 
    install_prerequisites
fi

get_ssh_keys
checkout_ansible_repository

if [ "$EUID" -eq 0 ]; then 
    ansible_system_setup
fi

ansible_rcpaffenroth_setup

source ~/.bashrc

