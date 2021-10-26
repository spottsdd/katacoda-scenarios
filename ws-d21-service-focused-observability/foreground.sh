#!/bin/bash
statuscheck "tools"

export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres

[ ! -d "/root/lab" ] && mkdir /root/lab 

cd /root/lab

printf "DD_API_KEY=$DD_API_KEY\n\
DD_APP_KEY=$DD_APP_KEY\n\
POSTGRES_USER=$POSTGRES_USER\n\
POSTGRES_PASSWORD=$POSTGRES_PASSWORD\n" > /root/lab/.env 

clear

statusupdate "environment"
statuscheck "workspace"

statusupdate complete
prepenvironment