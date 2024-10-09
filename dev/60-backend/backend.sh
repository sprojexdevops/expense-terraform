#!/bin/bash

# values are passed terraform --> shell script --> ansible
component=$1
environment=$2
echo "Component: $component, Environment: $environment"
dnf install ansible -y
ansible-pull -i localhost, -U https://github.com/sprojexdevops/3tier-ansible-roles-tf.git main.yaml -e component=$component -e target_environment=$environment