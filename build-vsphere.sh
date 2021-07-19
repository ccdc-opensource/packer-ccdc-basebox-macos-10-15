#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

if [[ -z "${VAGRANT_HOME}" ]]; then
  echo "Please set the VAGRANT_HOME environment variable explicitly"
  exit 1
fi

MACOS_VERSION=10.15
MACINBOX_IMAGE_NAME="macinbox-vsphere-10.15"
LAST_MACINBOX_VERSION=$(vagrant box list | grep $MACINBOX_IMAGE_NAME | tail -n 1 | perl -n -e'/vmware_desktop, (.+)\)/ && print $1')
echo "Using Vagrant box $MACINBOX_IMAGE_NAME, version $LAST_MACINBOX_VERSION"
echo 'creating output directory'
mkdir -p output

if [[ ! -e ./vsphere-environment-do-not-add ]]
then
  echo "Please add a vsphere-environment-do-not-add file to set up the environment variables required to deploy"
  echo "These vary based on the target VMWare server. The list can be found at the bottom of the packer template."
  return 1
fi
source ./vsphere-environment-do-not-add

echo 'cleaning up intermediate output'
rm -rf ./output/packer-vmware

# export PACKER_LOG='1'
echo 'building stage 1 macosx image for vsphere'
PACKER_LOG=1 packer build \
  -only=vmware-vmx \
  -except=vagrant \
  -on-error=ask \
  -var "macinbox_image_name=$MACINBOX_IMAGE_NAME" \
  -var 'guest_os_type=darwin18-64' \
  -var 'customise_for_buildmachine=1' \
  -var 'virtual_hw_version=18' \
  -var 'build_directory=./output/' \
  -var 'box_basename=ccdc-basebox/macos-$MACOS_VERSION' \
  -var 'vmx_remove_ethernet_interfaces=false' \
  -var "macinbox_vmx_location=$VAGRANT_HOME/boxes/$MACINBOX_IMAGE_NAME/$LAST_MACINBOX_VERSION/vmware_desktop/" \
  ./packer-add-vmware-tools.json

