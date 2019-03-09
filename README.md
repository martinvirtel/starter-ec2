# AWS EC2 Instance with ubuntu / web / ssh / docker


## Please edit variables.rf

... for the characteritics of the server to be launched. 

## Please edit config.makefile

... and add apointer to your aws credentials. Use `config.makefile-example` as a starting point.

Then run

`terraform apply`
`make put-bin-scripts put-vim-config put-ssh-config remote`

and 

`bin/initialize.sh` on the remote server. You will get Ubuntu 16.04 with docker, make and awscli







