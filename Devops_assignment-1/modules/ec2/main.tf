resource "aws_instance" "web_server" {
  ami                    = "ami-0fa91bc90632c73c9" 
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  key_name               = "private_key_1"
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]
  
  user_data = <<-EOF
    #!/bin/bash
    set -e
    
    echo "=========================================================="
    echo "||     Set up Docker's Apt repository ...............   ||"
    echo "=========================================================="
    
    # Update and install prerequisites
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg
    
    # Add Docker GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt-get update -y
    
    echo "=========================================================="
    echo "||   Docker repository setup completed ...............   ||"
    echo "=========================================================="
    
    # Install Docker
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Start and enable Docker
    systemctl start docker
    systemctl enable docker
    
    echo "=========================================================="
    echo "||   Docker installation completed ..................   ||"
    echo "=========================================================="
    
    # Verify installation
    dockerStatus=$(systemctl is-active docker)
    dockerVersion=$(docker --version | awk '{print $3}' | tr -d ',')
    
    echo "Docker status: $dockerStatus"
    echo "Docker version: $dockerVersion"

    apt-get install -y git
    git --version
    apt install docker-compose
    
  EOF
  
  tags = {
    Name = "web-server"
  }
}
