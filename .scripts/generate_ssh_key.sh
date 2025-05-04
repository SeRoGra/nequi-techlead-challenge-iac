#!/bin/bash
mkdir ./.ssh
ssh-keygen -f ./.ssh/key-nequi-techlead-challenge -t rsa
chmod -R 777 ./.ssh