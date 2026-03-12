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

	# Install 
	wget 

	# Now the rcpaffenroth user exists, so we can do the rest as that user.
	# We just give them a copy public_bootstrap and let them run the rest.
	sudo -u rcpaffenroth bash -c "cd /home/rcpaffenroth; git clone https://github.com/rcpaffenroth/public_bootstrap.git"
else
    echo "You need to run this script as root"
fi

echo "You can do something like the following to do the rest:"
echo "sudo su rcpaffenroth"
echo "cd /home/rcpaffenroth/public_bootstrap"
echo "bash ./rcpaffenroth.sh"
