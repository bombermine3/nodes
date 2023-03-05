#!/bin/bash

curl -s https://raw.githubusercontent.com/bombermine3/cryptohamster/main/logo.sh | bash && sleep 1

if [ $# -ne 1 ]; then 
	echo "Использование:"
	echo "shardeum.sh <command>"
	echo "	install   Установка ноды"
	echo "	uninstall Удаление"
	echo ""
fi

case "$1" in
install)
	apt update
	apt -y upgrade
	apt -y install curl
	apt -qq -y purge docker docker-engine docker.io containerd docker-compose > /dev/null 2>&1
	rm /usr/bin/docker-compose /usr/local/bin/docker-compose > /dev/null 2>&1
	curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
	systemctl restart docker

	curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose

	curl -O https://gitlab.com/shardeum/validator/dashboard/-/raw/main/installer.sh && chmod +x installer.sh && ./installer.sh

	cd $HOME/.shardeum
;;
uninstall)
	cd $HOME/.shardeum
	./cleanup.sh
	cd $HOME
	rm -rf .shardeum
	rm installer.sh
;;
esac
