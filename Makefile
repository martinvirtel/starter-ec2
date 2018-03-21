
SHELL := /bin/bash

SSH := $(shell terraform output ssh)
HOST := $(shell terraform output host)

PROJECT     ?= server
HOMEDIR     := /home/ubuntu

remote:
	expect -c 'spawn $(SSH) $(HOST); send "cd $(HOMEDIR);  tmux new-session -s $(PROJECT) || tmux attach -t $(PROJECT)\r"; interact '	


REMOTE:=echo Hello World
exec:
	echo REMOTE=$(REMOTE) ;\
	$(SSH) $(HOST) $(REMOTE)



get-bin-scripts:
	rsync -av -e "$(SSH)" $(HOST):/home/ubuntu/bin ./

put-bin-scripts:
	rsync -av -e "$(SSH)" ./bin/ $(HOST):/home/ubuntu/bin/
