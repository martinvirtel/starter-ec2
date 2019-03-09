#! /bin/bash

function upgrade {
    apt-get update
    apt-get -y install awscli make git python3-pip
    apt-get -y upgrade
}

function python_install {

   sudo add-apt-repository -y ppa:deadsnakes/ppa
   sudo apt-get update
   sudo apt-get -y install python3.6 python3.6-dev
   sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
   sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2
   curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
   sudo python3.6 ./get-pip.py
   rm ./get-pip.py
   sudo pip3 install fabric pipenv
}


function ssh_upgrade {

   TEMPDIR=/tmp/$$

   mkdir -p $TEMPDIR
   cd $TEMPDIR

   # https://gist.github.com/stefansundin/0fd6e9de172041817d0b8a75f1ede677

   wget https://launchpadlibrarian.net/335526589/openssh-client_7.5p1-10_amd64.deb
   wget https://launchpadlibrarian.net/298453050/libgssapi-krb5-2_1.14.3+dfsg-2ubuntu1_amd64.deb
   wget https://launchpadlibrarian.net/298453058/libkrb5-3_1.14.3+dfsg-2ubuntu1_amd64.deb
   wget https://launchpadlibrarian.net/298453060/libkrb5support0_1.14.3+dfsg-2ubuntu1_amd64.deb
   sudo dpkg -i libkrb5support0_1.14.3+dfsg-2ubuntu1_amd64.deb
   sudo dpkg -i libkrb5-3_1.14.3+dfsg-2ubuntu1_amd64.deb
   sudo dpkg -i libgssapi-krb5-2_1.14.3+dfsg-2ubuntu1_amd64.deb
   sudo dpkg -i openssh-client_7.5p1-10_amd64.deb

   cd -
}


function tmux_ssh_agent {

# https://werat.github.io/2017/02/04/tmux-ssh-agent-forwarding.html

cat <<__here__ >~/.ssh/rc
if [ ! -S ~/.ssh/ssh_auth_sock ] && [ -S "$SSH_AUTH_SOCK" ]; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
__here__

cat <<__here__ >~/.tmux.conf
set-environment -g 'ssh_auth_sock' ~/.ssh/ssh_auth_sock
__here__


}



function docker_install {
 apt-get -y install \
         apt-transport-https\
         ca-certificates  \
         curl     \
         software-properties-common
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
 apt-get update
 apt-get -y install docker-ce
 service docker start
 systemctl enable docker
 groupadd docker
 docker run hello-world
 # On AWS: Init Swarm with internal IP Address
 docker swarm init --advertise-addr 127.0.0.1
 # $(uname -a | grep aws >/dev/null && curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
}

function locale {
	locale-gen de_DE.UTF-8
	update-locale
}

function ssh-agent-service {
	# https://stackoverflow.com/a/38980986/2743441
	mkdir -p ~/.config/systemd/user/
	if [ ! -f ~/.config/systemd/user/ssh-agent.service ] ; then
	cat <<__here__ > ~/.config/systemd/user/ssh-agent.service
[Unit]
Description=SSH key agent

[Service]
Type=forking
Environment=SSH_AUTH_SOCK=%t/ssh-agent.socket
ExecStart=/usr/bin/ssh-agent -a $SSH_AUTH_SOCK

[Install]
WantedBy=default.target
__here__
	fi
	

}


if [[ $EUID -eq 0 ]]; then
    upgrade
	locale
	docker_install
	dpkg-reconfigure --priority=low unattended-upgrades
    python_install
    ssh_upgrade
else 
	sudo $0 
 	sudo usermod -aG docker $USER
	ssh-agent-service
  	systemctl --user enable ssh-agent
  	systemctl --user start ssh-agent
    git config --global user.email "martin.virtel@gmail.com"
    tmux_ssh_agent
fi

