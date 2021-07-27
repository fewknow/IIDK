#!/bin/bash

set -e

echo "Setting tmp file from file final"
FILE_FINAL=/etc/consul.d/consul_agent.json
FILE_TMP=$FILE_FINAL.tmp

echo "Remove bind_addr for contianer"
sed -i -- "/bind_addr/ d" $FILE_TMP

echo "Replacing strings for config file"

echo "Replacing string instace_id"
sed -i -- "s/{{ instance_id }}/$HOSTNAME/g" $FILE_TMP

echo "Replacing string region"
sed -i -- "s/{{ region }}/$REGION/g" $FILE_TMP

echo "Replacing string consul_servers"
sed -i -- "s/{{ consul_servers }}/$CONSUL_SERVERS/g" $FILE_TMP

echo "Replacing string encryption_key"
sed -i -- "s/{{ encrypt_key }}/$ENCRYPT_KEY/g" $FILE_TMP

echo "Replacing ACL master token"
sed -i -- "s/{{ acl_master_token }}/$ACL_MASTER_TOKEN/g" $FILE_TMP

echo "Replacing final file with tmp"
mv $FILE_TMP $FILE_FINAL

echo "Finished initializing consul agent config file"
