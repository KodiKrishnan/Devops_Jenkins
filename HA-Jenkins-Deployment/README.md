# HA Jenkins Automation – Quick Execution Guide

This project deploys a **Highly Available Jenkins** setup using **Immutable Infrastructure**, **Infrastructure as Code**, and **Externalized Secrets**.

## Tools Used
- **Packer** – Build Jenkins Controller & Agent AMIs  
- **Ansible** – Configure AMIs during Packer build  
- **Terraform** – Provision AWS resources  
- **AWS Parameter Store** – Store SSH keys  
- **Python/Boto3** – Retrieve SSH keys inside AMIs  
- **GitHub** – Source repository

## AWS Services Used
- IAM (Instance Profiles)
- EFS (Jenkins persistent storage)
- SSM Parameter Store
- Autoscaling Groups (Controllers & Agents)
- Application Load Balancer (Static DNS)
- EC2 (AMI-based immutable instances)
- VPC & Subnets (Public/Private)

---

# 1. Prerequisites
Install and configure:

```
Packer
Terraform
Ansible
AWS CLI (configured with ap-southeast-1 region)
```

---

# 2. Folder Structure
```
01-jenkins-setup/
    ansible/
    packer/
    terraform/
```

---

# 3. Create SSH Key & Store in Parameter Store
```
ssh-keygen
```

Store keys:
```
aws ssm put-parameter --name /devops-tools/jenkins/id_rsa --type SecureString --value "$(cat id_rsa)"
aws ssm put-parameter --name /devops-tools/jenkins/id_rsa.pub --type SecureString --value "$(cat id_rsa.pub)"
```

---

# 4. Create IAM Role for Jenkins
```
cd terraform/iam
terraform init
terraform apply --auto-approve
```

---

# 5. Create EFS
```
cd terraform/efs
terraform init
terraform apply --auto-approve
```

---

# 6. Build Jenkins Controller AMI
```
cd 01-jenkins-setup
packer build -var "efs_mount_point=<EFS_DNS>" jenkins-controller.pkr.hcl
```

---

# 7. Build Jenkins Agent AMI
```
packer build -var "public_key_path=/devops-tools/jenkins/id_rsa.pub" jenkins-agent.pkr.hcl
```

---

# 8. Deploy Controller ASG + Load Balancer
```
cd terraform/lb-asg
terraform init
terraform apply --auto-approve
```

Access Jenkins:
```
https://<ALB-DNS>
```

---

# 9. Unlock Jenkins
```
sudo cat /data/jenkins/secrets/initialAdminPassword
```

---

# 10. Deploy Jenkins Agent
```
cd terraform/agent
terraform init
terraform apply --auto-approve
```

---

# 11. Validate
Agents should auto-connect in Jenkins UI.

---

# 12. Destroy Resources
```
terraform destroy --auto-approve
```

Deregister AMIs:
```
aws ec2 deregister-image --image-id <AMI_ID>
```

Delete Parameter Store:
```
aws ssm delete-parameter --name /devops-tools/jenkins/id_rsa
aws ssm delete-parameter --name /devops-tools/jenkins/id_rsa.pub
```

---

# 13. Done
This completes your HA Jenkins deployment workflow.
