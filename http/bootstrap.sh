#!/bin/bash
if [[ -z ${PACKAGE_HTTP_SERVER} ]]; then
  echo "Please set the PACKAGE_HTTP_SERVER environment variable."
  exit 1
fi

set -euo pipefail
IFS=$'\n\t'
shopt -s nullglob nocaseglob

PACKAGES=("packer.pkg" "setupsshlogin.pkg" "SkipAppleSetupAssistant-1.0.1.pkg" "vmware_tools.pkg")

# format the disk
diskutil eraseDisk APFS "Macintosh HD" disk0

# set sucatalog nvram. This may be a temp workaround.
# nvram IASUCatalogURL=https://swscan.apple.com/content/catalogs/others/index-10.16seed-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog

INSTALLPACKAGES=()
for package in "${PACKAGES[@]}"; do
  echo "Downloading ${package}"...
  curl -o "/var/root/${package}" "${PACKAGE_HTTP_SERVER}/${package}"
  INSTALLPACKAGES+=(--installpackage "${package}")
done

# run the installer with some error handling due to helper tool crashing sometimes
retrycount=0
retrylimit=5
until [[ "${retrycount}" -ge "${retrylimit}" ]]
do
  installer=$(find "/Volumes/Image Volume" -name startosinstall)
  ${installer} --agreetolicense "${INSTALLPACKAGES[@]}" --volume "/Volumes/Macintosh HD" && break
  retrycount=$((retrycount+1)) 
  echo "startosinstall failed. retrying in 20sec"
  sleep 20
done

if [[ "$retrycount" -ge "$retrylimit" ]]; then
  echo "startosinstall failed after ${retrylimit} attempts"
  tail  -n 30 /var/log/install.log
  exit 1
fi  

echo "Bootstrap Completed"
exit 0
