#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

cd $HOME

if [[ "$1" == "uninstall" ]]; then
    printf "${GREEN}Удаление ноды${NC}\n"
    sudo systemctl stop subspace-node
    sudo systemctl disable subspace-node
    sudo rm /etc/systemd/system/subspace-node.service
    sudo rm /usr/local/bin/subspace
    rm -rf $HOME/.local/share/subspace-cli/
    printf "${GREEN}Удаление завершено${NC}\n"
    exit
fi

printf "${GREEN}Обновление и установка зависимостей${NC}\n"
sudo apt -qq update
sudo apt -qq -y upgrade
sudo apt -y install wget

sudo wget -O /usr/local/bin/subspace https://github.com/subspace/subspace-cli/releases/download/v0.3.3-alpha/subspace-cli-ubuntu-x86_64-v3-v0.3.3-alpha
sudo chmod +x /usr/local/bin/subspace

printf "${GREEN}Настройка параметров${NC}\n"
/usr/local/bin/subspace init

printf "${GREEN}Запуск ноды${NC}\n"
printf "[Unit]
Description=Subspace Node
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/subspace farm --verbose
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/subspace-node.service > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable subspace-node
sudo systemctl restart subspace-node

printf "${GREEN}Установка завершена${NC}\n"
printf "${GREEN}Просмотр логов: journalctl -f -u subspace-node -o cat ${NC}\n"
