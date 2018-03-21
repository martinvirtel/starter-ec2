
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  # todo: data.aws_ami.ubuntu finds a new ami id, which forces a new resource.
  # try on another machine, if this would create a new block device too
  # ami           = "ami-13b8337c" #"${data.aws_ami.ubuntu.id}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"

  disable_api_termination = true
  monitoring = true 
  associate_public_ip_address = true 

  vpc_security_group_ids = [

      "${aws_security_group.web_ssh.id}"

  ]

  key_name = "${aws_key_pair.deployer.key_name}"

  root_block_device = {
      volume_type = "gp2"
      volume_size = "${var.volume_size}"
      delete_on_termination = false
  }



  tags {
    Name = "MPER Archive"
    Repository = ""
  }

#
# Test next time: upload public keys to instance - depends on terraform output
# provisioner "local-exec" {
#    command = "make get-public-keys update-authorized-keys "
#  }
# 

}



# Key
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file("${var.sshkey}.pub")}"
}

# Default VPC - not created, adopted
# https://www.terraform.io/docs/providers/aws/r/default_vpc.html

resource "aws_default_vpc" "default" {
}


# Security Group

resource "aws_security_group" "web_ssh" {
  name        = "web_ssh"
  description = "Allow ports 22, 80, 443"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.server.id}"
  vpc      = true
}

# Output

output "ssh" {
    value = "ssh -i ${var.sshkey}" 
}

output "host" {
    value = "ubuntu@${aws_eip.lb.public_ip}"
}

output "help" {
    value = "ssh -i ${var.sshkey} ubuntu@${aws_eip.lb.public_ip}"
}
