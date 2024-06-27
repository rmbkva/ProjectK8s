# Specify the AWS provider
provider "aws" {
  region = var.region  # Replace with your desired AWS region
}

resource "aws_vpc" "my" {
  cidr_block = var.vpc_cidr[0].cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.my.id
  cidr_block =  var.subnet_cidr[0].cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = var.subnet_cidr[0].sub_name
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.my.id
  cidr_block = var.subnet_cidr[1].cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = var.subnet_cidr[1].sub_name
  }
}

resource "aws_eip" "elastic" {
  instance = aws_instance.master.id
  vpc_id = aws_vpc.my.id
  # Optionally specify a VPC (if using VPC)
}

resource "aws_network_interface" "Ne" {
  subnet_id       = aws_subnet.subnet1.id  # Replace with your subnet ID
  security_groups = [aws_security_group.my-sg.id]  # Replace with your security group ID
}

resource "aws_network_interface_attachment" "ni" {
  instance_id          = aws_instance.master.id
  network_interface_id = aws_instance.master.network_interface_ids[0]
}

resource "aws_instance" "worker1" {
  ami           = "ami-04b70fa74e45c3917" # Example AMI ID, replace with your desired AMI
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id
}

resource "aws_instance" "worker2" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet2.id
}

resource "aws_instance" "master" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id
}

# resource "null_resource" "configure_master" {
#   depends_on = [aws_instance.master]

#   provisioner "local-exec" {
#     command = <<EOT
#       # Example: Install RKE on the master instance
#       ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.master.private_ip} 'curl -LO https://github.com/rancher/rke/releases/download/v1.2.5/rke_linux-amd64'
#       ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.master.private_ip} 'chmod +x rke_linux-amd64'
#       ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.master.private_ip} 'sudo mv rke_linux-amd64 /usr/local/bin/rke'
#       ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.master.private_ip} 'rke up --config cluster.yml'
      
#       # Any other commands or scripts you need to run on the master instance
#     EOT
#   }
# }

#DONT 
# resource "null_resource" "rke_provision" {
#   provisioner "remote-exec" {
#     connection {
#       host        = aws_instance.master.private_ip
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = file("~/.ssh/id_rsa")  # Replace with your SSH private key path
#     }

#     inline = [
#       "curl -LO https://github.com/rancher/rke/releases/download/v1.2.5/rke_linux-amd64",
#       "chmod +x rke_linux-amd64",
#       "sudo mv rke_linux-amd64 /usr/local/bin/rke",
#       "rke up --config cluster.yml"  # Execute RKE to create Kubernetes cluster
#     ]
#   }
# }
#DONT
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.my.id
  name   = "sg"
}
#Create an EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn  # Replace with your IAM role ARN for EKS (if using)

  vpc_config {
    subnet_ids         = var.subnet_ids  # Replace with your subnet IDs
    security_group_ids = var.security_group_ids # Replace with your security group IDs
  }
}

# IAM role for EKS cluster
resource "aws_iam_role" "eks_role" {
  name = "my-eks-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      },
    ]
  })
}

# IAM role policy attachment
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# # Output EKS cluster details
# output "eks_cluster_name" {
#   value = aws_eks_cluster.my_cluster.name
# }

# output "eks_cluster_endpoint" {
#   value = aws_eks_cluster.my_cluster.endpoint
# }

# output "eks_cluster_certificate_authority_data" {
#   value = aws_eks_cluster.my_cluster.certificate_authority.0.data
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config"  # Path to your kubeconfig file
# }

# data "template_file" "k8s_yaml" {
#   template = file("templates/k8s.tpl")  # Example template file path
  
#   // You can optionally pass variables to your template here
#   vars = {
#     subnet_id = aws_subnet.subnet1.id
#     // other variables needed by your template
#   }
# }
# resource "kubernetes_manifest" "pods" {
#   manifest = file("k8s.yaml")
# }
