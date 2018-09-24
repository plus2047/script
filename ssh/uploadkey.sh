#! /bin/bash
ssh $1 'mkdir .ssh && chmod 700 .ssh'
scp ./id_rsa.pub $1:.ssh/authorized_keys
ssh $1 'ls .ssh'


