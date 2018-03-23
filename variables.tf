
# Name of the server

variable name {
  default  = "Reserve-Server Versicherungsmonitor.de",
}           

variable slug {
   default =  "vm-server"
}


# Secret Key File

variable sshkey {
  default = "~/.ssh/id_martinvirtel_server_2017"
}


# Volume size in GB

variable volume_size {
 default = 64 
}


# Instance Type
# List: https://aws.amazon.com/ec2/instance-types/

variable instance_type {
 default = "t2.medium"
}
