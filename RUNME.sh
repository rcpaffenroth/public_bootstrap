#! /bin/bash

# This can be gotten using
#
#  wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/RUNME.sh 
#  
#  or
#
#  wget bit.ly/RCPrunme
#
#  To get started from a really clean system
#
#  apt-get update && apt-get install -y wget && wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/RUNME.sh && bash ./RUNME.sh

# I would like to run as much as possible through ansible.  
# I have a vault with my private ssh key, and this makes things muich cleaner.

umask 022

function install_prerequisites() {
	export DEBIAN_FRONTEND=noninteractive
	apt update
	apt install -y software-properties-common
	# To get the newest version
	apt-add-repository --yes --update ppa:ansible/ansible
	apt install -y ansible git openssh-client
}

if [ "$EUID" -eq 0 ]; then 
    echo "running as root"    
    echo "Installing prerequisites"
    install_prerequisites
	# echo "Get ansible bootstrap"
	# WORKDIR=`mktemp -d`
	# mkdir -p $WORKDIR
	# cd $WORKDIR
	cd $HOME
	git clone https://bitbucket.org/rcpaffenroth/public_bootstrap.git
	cd public_bootstrap/ansible
	git pull
	ansible-playbook --ask-vault-password bootstrap.yml
	eval `ssh-agent -s`
	# Note, this is $HOME for root
	ssh-add $HOME/.ssh/id_ed25519
	ansible-playbook setup-ssh.yml
else
    echo "You need to run this script as root"
fi

