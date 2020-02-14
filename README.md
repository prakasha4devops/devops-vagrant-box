# DevOps box
* A vagrant project with an ubuntu box with the tools needed to do DevOps

# tools included
* Terraform
* AWS CLI
* Ansible

# to up the vagrant box
 vagrant up  
# Install Vagrant plugin, to mount VirtualBox shared folders.

vagrant plugin install vagrant-vbguest vagrant-disksize vagrant-winnfsd

# To login into box execute:

vagrant ssh

if you get any error while doing vagrant up , please run vagrant reload --provision command on your machine
