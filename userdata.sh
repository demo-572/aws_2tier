#!/bin/bash -v
sudo apt-get update -y

sudo apt install docker.io

sudo usermod -aG docker ubuntu

