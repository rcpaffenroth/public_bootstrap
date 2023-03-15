#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get .ssh
cd $HOME
rsync -av rcpaffenroth@mournblade.wpi.edu:.ssh .ssh_rcp
ln -s .ssh_rcp/config .ssh/config
ln -s .ssh_rcp/keys .ssh/keys

# Next we get .rcp with the keys in there
rsync -av rcpaffenroth@mournblade.wpi.edu:.rcp .

# Next we get the rest of the stuff using ansible
if [ -d "/path/to/dir" ] 
then
    echo "Using current ansible" 
else
    echo "Downloading ansible"
    mkdir -p projects
    cd projects
    git clone git@bitbucket.org:rcpaffenroth/ansible.git
fi

# Note, rcpaffenroth does not necessarily have passwordless sudo at this point.
cd $HOME/projects/ansible && ansible-playbook -i inventory/localhost.ini --ask-become-pass playdir/system_setup.yml
cd $HOME/projects/ansible && bin/update_local_rcpaffenroth
