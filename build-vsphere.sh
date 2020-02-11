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

MACOS_VERSION=10.15
LAST_MACINBOX_VERSION=$(vagrant box list | grep ccdc-basebox-macosx-10.15 | tail -n 1 | perl -n -e'/vmware_desktop, (.+)\)/ && print $1')
echo "Using Vagrant box ccdc-basebox-macosx-10.15, version $LAST_MACINBOX_VERSION"
echo 'creating output directory'
mkdir -p output

rm -rf ./output/packer-vmware

echo 'building base images'
PACKER_LOG=1 packer build \
  -only=vmware-vmx \
  -on-error=ask \
  -var 'guest_os_type=darwin18-64' \
  -var 'customise_for_buildmachine=1' \
  -var 'virtual_hw_version=15' \
  -var 'build_directory=./output/' \
  -var 'box_basename=ccdc-basebox/macos-$MACOS_VERSION' \
  -var 'vmx_remove_ethernet_interfaces=false' \
  -var "macinbox_vmx_location=$VAGRANT_HOME/boxes/ccdc-basebox-macosx-$MACOS_VERSION/$LAST_MACINBOX_VERSION/vmware_desktop/" \
  ./packer-add-vmware-tools.json

