
# Name of the server

variable name {
  default  = "readerboard_2019",
}           

variable slug {
   default =  "rb2019"
}


# Secret Key File

variable sshkey {
  default = "~/.ssh/id_martinvirtel_server_2018"
}


# Volume size in GB

variable volume_size {
 default = 32 
}


# Instance Type
# List: https://aws.amazon.com/ec2/instance-types/

variable instance_type {
 default = "t2.medium"
}

