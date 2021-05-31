#!/bin/bash
#hostname
apt -y update
apt -y install docker.io ansible unzip

usermod -G docker


# install pip
apt -y install  python3.8
apt -y install python3-pip
python3.8 -m pip install --user --upgrade pip
