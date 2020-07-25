#!/bin/bash

set -x
if [ ! -e ~/jenkins.done ]; then
  echo "Installing the jenkins."
  #Install Java 8
  sudo apt install -y openjdk-8-jdk

  #Check the java version installed
  java -version

  # Install Jenkins
  ## Before install is necessary to add Jenkins to trusted keys and source list
  wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCEF32E745F2C3D5
  sudo apt-get update
  sudo apt-get install -y jenkins

  sudo systemctl start jenkins

  systemctl status jenkins


  echo "By default Jenkins will run on port 8080. To start Jenkins type in the IP of your VPS and the port number 8080"

  sudo cat /var/lib/jenkins/secrets/initialAdminPassword

  touch ~/jenkins.done

fi
