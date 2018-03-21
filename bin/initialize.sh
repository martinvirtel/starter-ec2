#! /bin/bash

function upgrade {
    apt-get update
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
 groupadd docker
 docker run hello-world
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

