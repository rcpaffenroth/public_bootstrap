#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get ssh keys and configuration
cd $HOME
rsync -av rcpaffenroth@mournblade.wpi.edu:.ssh_rcp .
bash .ssh_rcp/setup.sh

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
    git clone git@github.com:rcpaffenroth/ansible.git
fi

eval `ssh-agent -s`
ssh-add
# Note, rcpaffenroth does not necessarily have passwordless sudo at this point.
$HOME/projects/ansible/bin/update_local_system
$HOME/projects/ansible/bin/update_local_rcpaffenroth
