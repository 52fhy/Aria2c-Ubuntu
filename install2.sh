#!/bin/bash

sed -i "s#/tmp#${HOME}/下载#g" aria2.conf
sed -i "s#User=root#User=${USER}#g" aria2.service

sudo mkdir /etc/aria2/
sudo touch /etc/aria2/aria2.session

sudo cp aria2.conf /etc/aria2/aria2.conf

sudo cp aria2.service /etc/systemd/system/aria2.service

sudo systemctl enable aria2
sudo systemctl start aria2



