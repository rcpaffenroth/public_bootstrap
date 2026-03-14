#! /bin/bash

# This script can be run by the rcpaffenroth user to do a basic setup.
# First we get ssh keys and configuration
cd $HOME
rsync -av rcpaffenroth@setup.rcpaffenroth.org:.rcp .

# Need to get gh cli for the next step, but we don't have it yet. So we'll do it manually.
# we just download the binary and put it in the path. This is a bit hacky, but it works.
wget https://github.com/cli/cli/releases/download/v2.88.1/gh_2.88.1_linux_amd64.tar.gz
tar -xzf gh_2.88.1_linux_amd64.tar.gz
PATH="$HOME/gh_2.88.1_linux_amd64/bin:$PATH"
export GH_TOKEN=$(cat .rcp/github-token)

# Next we get the rest of the stuff using ansible
gh repo clone git@github.com:rcpaffenroth/ansible 

eval `ssh-agent -s`
ssh-add
# Note, rcpaffenroth does not necessarily have passwordless sudo at this point.
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i inventory/localhost.ini playdir/system_setup.yml
ansible-playbook -i inventory/localhost.ini playdir/rcpaffenroth_setup.yml
