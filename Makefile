
SHELL := /bin/bash


include config.makefile config_terraform.makefile

.terraform:
	$(MAKE) terraform init

terraform.tfstate: ubuntu-ec2-server.tf 
	-$(AWS_CREDENTIALS) terraform refresh

config_terraform.makefile: terraform.tfstate
	terraform output makefile >$@


PROJECT     ?= server
HOMEDIR     ?= /home/ubuntu

# remote:
#	expect -c 'spawn $(SSH) -A $(HOST); send "cd $(HOMEDIR);  tmux new-session -s $(PROJECT) || tmux attach -t $(PROJECT)\r"; interact '	


REMOTE:=echo Hello World
exec:
	echo REMOTE=$(REMOTE) ;\
	$(SSH) $(HOST) $(REMOTE)


TF := show
terraform:
	@echo terraform TF=$(TF) ;\
	$(AWS_CREDENTIALS) terraform $(TF)

AWS := hello
aws:
	echo aws AWS=$(AWS) ;\
	$(AWS_CREDENTIALS) aws $(AWS)

get-bin-scripts:
	rsync -av -e "$(SSH)" $(HOST):/home/ubuntu/bin ./

put-bin-scripts:
	rsync -av -e "$(SSH)" ./bin/ $(HOST):/home/ubuntu/bin/

put-vim-config:
	rsync -av -e "$(SSH)" ~/$$(readlink ~/.vimrc) $(HOST):/home/ubuntu/.vimrc && \
	rsync -av -e "$(SSH)" ~/.vim/ $(HOST):/home/ubuntu/.vim/


put-ssh-config:
	rsync -av -e "$(SSH)" ~/.ssh/deploy.d/ $(HOST):/home/ubuntu/.ssh/deploy.d &&\
	printf "Please insert\n\nInclude deploy.d/*.conf\n\ninto your ~/.ssh/config"


plan:
	$(MAKE) terraform TF=plan

apply:
	$(MAKE) terraform TF=apply

remote: 
	expect -c 'spawn $(SSH) $(HOST); send "mkdir -p $(HOMEDIR); cd $(HOMEDIR); tmux new-session -s $(PROJECT) || tmux attach -t $(PROJECT)\r"; interact '


start-instance:
	$(AWS_CREDENTIALS) aws ec2 start-instances --instance-ids=$(INSTANCE)

stop-instance:
	$(AWS_CREDENTIALS) aws ec2 stop-instances --instance-ids=$(INSTANCE)

query-instance:
	@printf "$(INSTANCE) state: " ;\
	$(AWS_CREDENTIALS) aws ec2 describe-instances --instance-ids=$(INSTANCE) --query=Reservations[].Instances[].State.Name --output=text

