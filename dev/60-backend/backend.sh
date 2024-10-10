#!/bin/bash

# values are passed from terraform --> shell script --> ansible
component=$1
environment=$2
echo "Component: $component, Environment: $environment"
sudo dnf -y install ansible
ansible-pull -i localhost, -U https://github.com/sprojexdevops/3tier-ansible-roles-tf.git main.yaml -e component=$component -e target_environment=$environment