#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get .ssh
rsync -av rcpaffenroth@haven.rcpaffenroth.org:.ssh .ssh.new
mv .ssh .ssh.old
mv .ssh.new .ssh

# Next we get .rcp with the keys in there
rsync -av rcpaffenroth@haven.rcpaffenroth.org:.rcp .

# Next we get the rest of the stuff using ansible
mkdir -p projects
cd projects
git clone git@bitbucket.org:rcpaffenroth/ansible.git
cd ansible
bin/update_local_system
bin/update_local_rcpafferoth
