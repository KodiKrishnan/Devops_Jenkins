#!/bin/bash

# Update the package lists
sudo apt update

# Install required packages
sudo apt install -y default-jdk

# Add the Jenkins repository key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

# Start and enable the Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Open the firewall port (optional, if you have a firewall)
#sudo ufw allow 8080/tcp

echo "Jenkins is installed and running. Access it at http://localhost:8080"
