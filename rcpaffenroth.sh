#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get .ssh
cd $HOME
rm -rf .ssh.new .ssh.old
rsync -av rcpaffenroth@haven.rcpaffenroth.org:.ssh .ssh.new
mv .ssh .ssh.old
mv .ssh.new/.ssh .ssh
rm -rf .ssh.new

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

# Note, rcpaffenroth does not necessarily have passwordless sudo at this point.
ansible-playbook -i inventory/localhost.ini --ask-become-pass playdir/system_setup.yml
bin/update_local_rcpafferoth
