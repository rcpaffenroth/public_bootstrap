#! /bin/bash

# This script can be run by the root user to do a basic setup.
# It will install a few prequisites, including an ssh server,  and then setup a rcpaffenroth user.

# This can be gotten using
#
#  wget bit.ly/RCPrunme
#  
#  or, more verbosely,
#
#  wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/RUNME.sh 
#
#  To get started from a really clean system
#
#  apt-get update && apt-get install -y wget && wget bit.ly/RCPrunme && bash ./RCPrunme

# Once you have the rcpaffenroth user setup by this script, 
# there are two ways to proceed:
# 
# 1. Run ansible on some already setup host, point at this
#	 node, and let it do the rest.
# 2. Download the additional script below and run it as rcpaffenroth.
#	wget https://raw.githubusercontent.com/rcpaffenroth/public_bootstrap/master/rcpaffenroth.sh

umask 022

if [ "$EUID" -eq 0 ]; then 
    echo "running as root"    
    echo "Installing prerequisites"
	export DEBIAN_FRONTEND=noninteractive
	apt update
	apt install -y software-properties-common ansible git openssh-client
	echo "Get ansible bootstrap"
	cd $HOME
	git clone https://github.com/rcpaffenroth/public_bootstrap.git
	cd public_bootstrap/ansible
	git pull
	ansible-playbook bootstrap.yml
else
    echo "You need to run this script as root"
fi

echo "You can do the following to do the rest:"
echo "wget https://raw.githubusercontent.com/rcpaffenroth/public_bootstrap/master/rcpaffenroth.sh"
echo "bash ./rcpaffenroth.sh"