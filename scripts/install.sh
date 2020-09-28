#!/bin/bash
set -x

echo "Running"
if [ ! -e ~/desktop.done ]
then

  if [ -e /etc/redhat-release ] ; then
    REDHAT_BASED=true
  fi


  TERRAFORM_VERSION="0.13.2"
  PACKER_VERSION="1.6.0"
  # create new ssh key
  [[ ! -f /home/ubuntu/.ssh/mykey ]] \
  && mkdir -p /home/ubuntu/.ssh \
  && ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
  && chown -R ubuntu:ubuntu /home/ubuntu/.ssh

  # install packages
  if [ ${REDHAT_BASED} ] ; then
    yum -y update
    yum install -y docker ansible unzip wget
  else
    apt-get update
    apt-get -y install docker.io ansible unzip
  fi
  # add docker privileges
  usermod -G docker ubuntu
  # install pip
  pip install -U pip && pip3 install -U pip
  if [[ $? == 127 ]]; then
      wget -q https://bootstrap.pypa.io/get-pip.py
      python get-pip.py
      python3 get-pip.py
  fi
  # install awscli and ebcli
  pip install -U awscli
  pip install -U awsebcli

  #terraform
  T_VERSION=$(/usr/local/bin/terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
  T_RETVAL=${PIPESTATUS[0]}

  [[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
  && wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

  # packer
  P_VERSION=$(/usr/local/bin/packer -v)
  P_RETVAL=$?

  [[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
  && wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
  && unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
  && rm packer_${PACKER_VERSION}_linux_amd64.zip


  touch ~/desktop.done

fi

# clean up
if [ ! ${REDHAT_BASED} ] ; then
    #update latest for security
  sudo apt-get -y update;
  sudo apt-get -y upgrade;
  sudo apt-get -y dist-upgrade

  sudo apt-get -y autoremove
  sudo  apt-get clean

else
  yum clean all
	#clean the package
	rm -rf /var/cache/yum
	rm -rf /var/tmp/yum-*
fi

