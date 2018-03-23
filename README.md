# AWS EC2 Instance with ubuntu / web / ssh / docker


## Please edit variables.rf

... for the characteritics of the server to be launched. And `config.makefile` for your aws credentials

Then run

`terraform apply`
`make put-bin-scripts remote`

and 

`bin/initialize.sh` on the remote server





