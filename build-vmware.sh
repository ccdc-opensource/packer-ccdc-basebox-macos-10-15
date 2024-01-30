#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

if [[ -z "${VAGRANT_HOME}" ]]; then
  echo "Please set the VAGRANT_HOME environment variable explicitly"
  exit 1
fi

MACOS_VERSION=10.14
MACINBOX_IMAGE_NAME="macinbox-vagrant-10.14"
LAST_MACINBOX_VERSION=$(vagrant box list | grep $MACINBOX_IMAGE_NAME | tail -n 1 | perl -n -e'/vmware_desktop, (.+)\)/ && print $1')
echo "Using Vagrant box $MACINBOX_IMAGE_NAME, version $LAST_MACINBOX_VERSION"
echo 'creating output directory'
mkdir -p output

# No need for all the environment variables in ./vsphere-environment-do-not-add
export VAGRANT_USER_FINAL_PASSWORD="vagrant"

echo 'cleaning up intermediate output'
rm -rf ./output-vagrant

echo 'building stage 1 macosx image for vagrant'
packer build \
  -only=vagrant \
  -except=vsphere,vsphere-template \
  -var "macinbox_image_name=$MACINBOX_IMAGE_NAME" \
  -var 'guest_os_type=darwin19-64' \
  -var 'virtual_hw_version=18' \
  -var 'build_directory=./output/' \
  -var 'box_basename=ccdc-basebox/macos-$MACOS_VERSION' \
  -var "macinbox_vmx_location=$VAGRANT_HOME/boxes/$MACINBOX_IMAGE_NAME/$LAST_MACINBOX_VERSION/vmware_desktop/" \
  ./packer-add-vmware-tools.json
