#! /bin/bash

# This script can be run by the root user to do a basic setup.
# It will install a few prequisites, including an ssh server,  and then setup a rcpaffenroth user.

# This can be gotten using
#
#  wget cutt.ly/RCPrunme
#  
#  or, more verbosely,
#
#  wget https://raw.githubusercontent.com/rcpaffenroth/public_bootstrap/master/RUNME.sh
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
	# Why these?  This ansible is needed for bootstrap.yml, but that is pretty basic, and will work with most
	# and version of ansible.  Eventually I will install a more recent version of ansible, but for now, this
	# is a good start.
	apt install -y software-properties-common ansible git \
	               openssh-client openssh-server sudo wget
	echo "Get ansible bootstrap"
	cd $HOME
	git clone https://github.com/rcpaffenroth/public_bootstrap.git
	cd public_bootstrap/ansible
	ansible-playbook bootstrap.yml

	# test that wget is in the path
	if ! [ -x "$(command -v wget)" ]; then
	  echo 'Error: wget is not installed.' >&2
	  exit 1
	fi
	# test that ssh is in the path
	if ! [ -x "$(command -v ssh)" ]; then
	  echo 'Error: ssh is not installed.' >&2
	  exit 1
	fi
	# test that scp is in the path
	if ! [ -x "$(command -v scp)" ]; then
	  echo 'Error: scp is not installed.' >&2
	  exit 1
	fi
	# test that sudo is in the path
	if ! [ -x "$(command -v sudo)" ]; then
	  echo 'Error: sudo is not installed.' >&2
	  exit 1
	fi
else
    echo "You are not running as root, so we will not do the initial setup. You can run this script as root to do the initial setup."
	echo "Proceeding with the rest of the setup as rcpaffenroth"
fi

su rcpaffenroth
cd $HOME
git clone https://github.com/rcpaffenroth/public_bootstrap.git
cd public_bootstrap
bash ./rcpaffenroth.sh
