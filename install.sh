#!/bin/bash

cd ~
mkdir aria2 && cd aria2
wget https://gitee.com/52fhy/Aria2c-Ubuntu/raw/main/aria2.conf
sed -i "s#/tmp#${HOME}/下载#g" aria2.conf
touch aria2.session

echo "aria2cd='nohup /usr/bin/aria2c --conf-path=${HOME}/aria2.conf &'" >> ~/.profile
source ~/.profile





