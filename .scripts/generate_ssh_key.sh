#!/bin/bash
HOME=./..

mkdir $HOME/.ssh
ssh-keygen -f $HOME/.ssh/key-nequi-techlead-challenge -t rsa
chmod -R 777 $HOME/.ssh