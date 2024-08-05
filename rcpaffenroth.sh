#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get ssh keys and configuration
cd $HOME
rsync -av rcpaffenroth@setup.rcpaffenroth.org:.ssh_rcp .
bash .ssh_rcp/setup.sh

# Next we get .rcp with the keys in there
rsync -av rcpaffenroth@setup.rcpaffenroth.org:.rcp .

# Next we get the rest of the stuff using ansible
git clone git@github.com:rcpaffenroth/ansible.git

eval `ssh-agent -s`
ssh-add
# Note, rcpaffenroth does not necessarily have passwordless sudo at this point.
cd ansible
# bash setup_venv.sh
# . venv/bin/activate
ansible-galaxy collection install -r requirements.yml
# ansible-playbook -i inventory/localhost_venv_python.ini playdir/system_setup.yml
# ansible-playbook -i inventory/localhost_venv_python.ini playdir/rcpaffenroth_setup.yml
ansible-playbook -i inventory/localhost.ini playdir/system_setup.yml
ansible-playbook -i inventory/localhost.ini playdir/rcpaffenroth_setup.yml
