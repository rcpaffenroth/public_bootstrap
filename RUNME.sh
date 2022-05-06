#! /bin/bash

# This can be gotten using
#
#  wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/RUNME.sh 
#  
#  or
#
#  wget bit.ly/RCPrunme
#
#  To get started from a really clean system
#
#  apt-get update && apt-get install -y wget && wget https://bitbucket.org/rcpaffenroth/public_bootstrap/raw/HEAD/RUNME.sh && bash ./RUNME.sh

# This is a subtle order dependence here.  I would like to run as much as possible
# through ansible.  However, that means I need access to the ansible repository,
# which is *private*.   So, I need my ssh keys to access that private repository.  
# However, to get those keys I need git and openssh.  
#  
# See the comments below for details.
#
# Perhaps a better way is to install just ansible, do an ansible pull, and they do
# the rest.  In particular, using ansible to install ssh keys *remotely* is very
# scary, since if the keys are ever inconsistent you can loose access!  However,
# perhaps it is not so scary if it is only done locally.

umask 022

function install_prerequisites() {
    if hash git 2>/dev/null; then
        echo "Using existing git"
    else
        apt update
        apt install -y git
    fi

    if hash ssh 2>/dev/null; then
        echo "Using existing ssh"
    else
        apt update
        apt install -y openssh-client
    fi

    if hash ansible 2>/dev/null; then
        echo "Using existing ansible"
    else
		export DEBIAN_FRONTEND=noninteractive
        apt update
        apt install -y software-properties-common
        # To get the newest version
        apt-add-repository --yes --update ppa:ansible/ansible
        apt install -y ansible 
    fi
}

# function get_ssh_keys() {
#     # Get my ssh keys
#     if [ -f "$HOME/.ssh/id_rsa" ]; then
#         echo "Using existing .ssh"
#     else
#         cd $HOME   
#         git clone https://bitbucket.org/rcpaffenroth/public_bootstrap.git
#         cd public_bootstrap/ansible
#         ansible-playbook --ask-vault-password --ask-pass bootstrap_ssh.yml
#         rm -rf $HOME/.ssh.bak  
#         mv $HOME/.ssh $HOME/.ssh.bak
#         mv ssh $HOME/.ssh
#         sh $HOME/.ssh/permissions.sh
#         eval `ssh-agent`
#         ssh-add $HOME/.ssh/id_rsa
#         cd $HOME
#         rm -rf public_bootstrap
#     fi
# }

# function get_vault_keys() {
#     # Get my vault key
#     if [ -f "$HOME/.rcp/ansible-vault" ]; then
#         echo "Using existing .rcp/ansible-vault"
#     else
#         mkdir $HOME/.rcp
#         chmod 700 $HOME/.rcp
#         rsync -av rcpaffenroth@moc-gateway.rcpaffenroth.org:.rcp/ansible-vault $HOME/.rcp/
#     fi
# }

# function checkout_ansible_repository() {
#     # Get ansible repository, since that is where the ansible playbooks are
#     if [ -d "$HOME/projects/ansible" ]; then
#         echo "Using existing projects/ansible"
#     else
#         mkdir -p $HOME/projects
#         git clone git@bitbucket.org:rcpaffenroth/ansible $HOME/projects/ansible
#     fi
# }

# function ansible_system_setup() {
#     cd $HOME/projects/ansible
#     ansible-playbook -i inventory/localhost.ini playdir/system_setup.yml
# }

# function ansible_rcpaffenroth_setup() {
#     cd $HOME/projects/ansible
#     ansible-playbook -i inventory/localhost.ini playdir/rcpaffenroth_setup.yml
# }

if [ "$EUID" -eq 0 ]; then 
    echo "running as root"    
    echo "Installing prerequisites"
    install_prerequisites
else
    echo "*not* running as root"
fi

echo "Get ansible bootstrap"
WORKDIR=`mktemp -d`
cd $WORKDIR
git clone https://bitbucket.org/rcpaffenroth/public_bootstrap.git
cd public_bootstrap/ansible
ansible-playbook --ask-vault-password --ask-pass bootstrap.yml

# # First install ssh and git
# if [ "$EUID" -eq 0 ]; then 
#     install_prerequisites
# fi

# # Need my ssh keys.  Note, this might be run as root or as rcpaffenroth
# # and either is ok
# get_ssh_keys
# # Checkout the ansible stuff.  Again, this might either be as root or as rcpaffenroth
# checkout_ansible_repository

# # We how have ansible ready to go, and can do the system.
# # Internally, this runs as whatever it needs to run as.
# if [ "$EUID" -eq 0 ]; then 
#     get_vault_keys
#     ansible_system_setup
# fi

# # Now, the root stuff is done.  We can now setup rcpaffenroth.  
# # You might need to run this *twice*  Once as root and once as rcpaffenroth
# if [ "$EUID" -ne 0 ]; then 
#     get_vault_keys
#     eval `ssh-agent`
#     ssh-add
#     ansible_rcpaffenroth_setup
#     source ~/.bashrc
# fi

