#!/bin/bash

# Update the package lists
sudo apt update

# Install required packages
sudo apt install -y default-jdk

# Add the Jenkins repository key
echo "deb [signed-by=/var/lib/dpkg/archive/keyrings/jenkins-keyring] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key 1  | sudo gpg --dearmor -o /var/lib/dpkg/archive/keyrings/jenkins-keyring

# Update the package lists again
sudo apt update

# Install Jenkins
sudo apt install -y jenkins

# Start and enable the Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Open the firewall port (optional, if you have a firewall)
#sudo ufw allow 8080/tcp

echo "Jenkins is installed and running. Access it at http://localhost:8080"
