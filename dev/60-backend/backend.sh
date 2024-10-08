#!/bin/bash

#get the values from terraform
component=$1
environment=$2         
#echo "Component: $component, Environment: $environment"
#pass values to ansible playbook from shell script
dnf install ansible -y
ansible-pull -i localhost, -U https://github.com/sprojexdevops/3tier-ansible-roles-tf.git main.yaml -e component=$component -e target_environment=$environment