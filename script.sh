# #Install aws configure 
# curl -o awscliv2.sig https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip.sig
# unzip awscliv2.zip
# sudo ./aws/install
# # Create User in AWS console ,create access and secret key .

# cd aws 

# #Then provide keys and region  in aws configure command 

# cd Terraform 
# terraform init 
# terraform apply 
# aws eks --region us-east-1  update-kubeconfig --name my-eks-cluster

# cd ..
# sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
# chmod +x ./kubectl
# sudo mv ./kubectl /usr/local/bin/kubectl 

#!/bin/bash

# Run Terraform apply to create resources
terraform apply -auto-approve

# Retrieve output values
subnet_ids=$(terraform output -raw subnet_ids)
security_group_id=$(terraform output -raw security_group_id)

# Use these IDs in further commands or scripts
echo "Subnet IDs: $subnet_ids"
echo "Security Group ID: $security_group_id"

# Example: Pass these IDs to another script or command
./another_script.sh "$subnet_ids" "$security_group_id"