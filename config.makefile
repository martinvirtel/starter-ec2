
AWS_PROFILE := versicherungsmonitor
AWS_DEFAULT_REGION := eu-central-1

# optional 
# PROJECT     := server
# HOMEDIR     := /home/ubuntu


AWS_CREDENTIALS := AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) AWS_PROFILE=$(AWS_PROFILE)


# those below may be overwritten by "make config_terraform.makefile"
HOST   := ubuntu@18.194.22.26
SSH     := ssh -A -i ~/.ssh/id_martinvirtel_server_2016.pub 
LOGIN   := $(SSH) $(LOGIN)
INSTANCE := i-045fdc3f16c85b557


