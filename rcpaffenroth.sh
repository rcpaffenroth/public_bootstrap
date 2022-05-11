#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get .ssh
cd $HOME
rsync -av rcpaffenroth@haven.rcpaffenroth.org:.ssh .ssh.new
mv .ssh .ssh.old
mv .ssh.new .ssh

# Next we get .rcp with the keys in there
rsync -av rcpaffenroth@haven.rcpaffenroth.org:.rcp .

# Next we get the rest of the stuff using ansible
if [ -d "/path/to/dir" ] 
then
    echo "Using current ansible" 
    cd projects/ansible
else
    echo "Downloading ansible"
    mkdir -p projects
    cd projects
    git clone git@bitbucket.org:rcpaffenroth/ansible.git
    cd ansible
fi

bin/update_local_system
bin/update_local_rcpafferoth
