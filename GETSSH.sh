#! /bin/bash

# wget https://bitbucket.org/rcpaffenroth/setupcomputer/raw/HEAD/GETSSH.sh 

export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"
rm -rf $HOME/.ssh.bak $HOME/ssh 
git clone rcpaffenroth@haven.rcpaffenroth.org:repos/ssh.git $HOME/ssh
mv $HOME/.ssh $HOME/.ssh.bak
mv $HOME/ssh $HOME/.ssh
sh $HOME/.ssh/permissions.sh
eval `ssh-agent`
ssh-add $HOME/.ssh/id_rsa
