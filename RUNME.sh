#! /bin/bash

# This script can be run by the root user to do a basic setup.
# It will install a few prequisites and then setup a rcpaffenroth user.

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

# Once you have the rcpaffenroth user setup by this script, 
# there are two ways to proceed:
# 
# 1. Run ansible on some already setup host and point at this
#	 node let it do the rest.
# 2. Download the additional script below and run it as rcpaffenroth.
#	wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/rcpaffenroth
umask 022

if [ "$EUID" -eq 0 ]; then 
    echo "running as root"    
    echo "Installing prerequisites"
	export DEBIAN_FRONTEND=noninteractive
	apt update
	apt install -y software-properties-common
	# To get the newest version
	apt-add-repository --yes --update ppa:ansible/ansible
	apt install -y ansible git openssh-client
	echo "Get ansible bootstrap"
	cd $HOME
	git clone https://bitbucket.org/rcpaffenroth/public_bootstrap.git
	cd public_bootstrap/ansible
	git pull
	ansible-playbook bootstrap.yml
else
    echo "You need to run this script as root"
fi

