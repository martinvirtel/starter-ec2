
# Secret Key File

variable sshkey {
  default = "~/.ssh/id_martinvirtel_server_2017"
}


# Volume size in GB

variable volume_size {
 default = 128
}


# Instance Type
# List: https://aws.amazon.com/ec2/instance-types/

variable instance_type {
 default = "t2.medium"
}
