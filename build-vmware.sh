#!/bin/bash
if [[ -z "${VAGRANT_HOME}" ]]; then
  echo "Please set the VAGRANT_HOME environment variable explicitly"
  exit 1
fi

MACOS_VERSION=10.15
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

echo 'cleaning up intermediate output'
rm -rf ./output-vagrant

echo 'building image with vmware tools'
packer build \
  -only=vagrant \
  -except=vsphere,vsphere-template \
  -var 'guest_os_type=darwin19-64' \
  -var 'virtual_hw_version=16' \
  -var 'build_directory=./output/' \
  -var 'box_basename=ccdc-basebox/macos-$MACOS_VERSION' \
  ./packer-add-vmware-tools.json

