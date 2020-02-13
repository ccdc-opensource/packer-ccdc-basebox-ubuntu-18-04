#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

if [[ ! -e ./vsphere-environment-do-not-add ]]
then
  echo "Please add a vsphere-environment-do-not-add file to set up the environment variables required to deploy"
  echo "These vary based on the target VMWare server. The list can be found at the bottom of the packer template."
  return 1
fi
source ./vsphere-environment-do-not-add

echo 'creating output directory'
mkdir -p output
rm -rf ./output/packer-ubuntu-18.04-amd64-vmware

echo 'building base images'
packer build \
  -only=vmware-iso \
  -except=vagrant \
  -var 'customise_for_buildmachine=1' \
  -var 'build_directory=./output/' \
  -var 'disk_size=400000' \
  -var 'cpus=2' \
  -var 'memory=4096' \
  -var 'vmx_remove_ethernet_interfaces=false' \
  -var 'box_basename=ccdc-basebox/ubuntu-18.04' \
  ./ubuntu-18.04-amd64.json

