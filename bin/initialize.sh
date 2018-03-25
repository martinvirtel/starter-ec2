#! /bin/bash

function upgrade {
    apt-get update
    apt-get -y install awscli make 
    apt-get -y upgrade
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

if [[ $EUID -eq 0 ]]; then
    update
	locale
	docker_install
	dpkg-reconfigure --priority=low unattended-upgrades

else 
	sudo $0 
 	sudo usermod -aG docker $USER
fi

