# CCDC Basic MacOS Vagrant box

The instructions and files in this directory make it possible (not easy!) to set up a basic MacOS box that can be used via Vagrant.

Standard vagrant commands can be used to start, provision, stop the VM itself.
Building the box requires studying, asking questions that have complicated answers and understanding what's going on.

## Requirements to build this:
- MacOS 10.15
- VMWare Fusion (licence required)
- Vagrant
- vagrant-vmware-desktop plugin (licence required)
- vagrant-vmware-utility
- packer
- macinbox (see below for instructions)
- a lot of free disk space

Installation of most requirements can be done via brew.sh: brew install packer vagrant

VMWare Fusion must be installed from the vmware package.
Once vagrant has been installed, the vagrant plugin and vagrant vmware utility must be installed separately
- Vagrant plugin installation instructions are here: https://www.vagrantup.com/docs/vmware/installation.html
- Vagrant vmware utility can be found here: https://www.vagrantup.com/docs/vmware/vagrant-vmware-utility.html

## Base image and how to generate one

Creating a basic macos image is something of a black art. Each os version has brought changes that make the required steps different. Apparently Apple doesn't provide any sort of public contract there and don't care about OS virtualisation at all.

Creating a base image for mac os 10.12 and 10.13 can be done with the packer package. There are in fact multiple blog posts and repositories providing packer templates for the job. It's a task on it's own to weed through all the information and find the solution that fits.

With mac os 10.14 Mojave, noone found a way to provide a packer template to do this. What can be found (Sept 2019) is a ruby gem called macinbox. To use it, one should install it via

    sudo gem install macinbox

NOTE: This will alter the system ruby install!

To create a base image, one should:
- consider export VAGRANT_HOME=/Volumes/some volume with enough space to do all this stuff!
- temporarily disable Sophos Antivirus agent as it seems to create a situation where the virtual disks used to create the base image refuse to mount with a permissions error. IF this happens, try restarting the mac, disabling the antivirus on startup and repeat the process.
- run softwareupdate to obtain the mac os installer. An example command line is this
    softwareupdate --fetch-full-installer --full-installer-version 10.15.3
- run sudo build-base-macosx-image

This will run macinbox and create a basic MacOS 10.15 image with 400Gb of disk and a default vagrant user. VMWare tools is not installed
The image is stored in your VAGRANT_HOME directory, along with other boxes that you might be using

## Generating an image with VMWare tools

Once the basic image is generated, one must use packer to add VMWare tools

Unfortunately some manual intervention is required.

Run packer packer-add-vmware-tools.json

Packer will clone the basic VM, download VMWare tools, try to install it and fail as the kernel extension will be blocked by Apple's enlightened security system
Packer will then stop and wait for you to:

- head to the VM console
- click on Open Security Preferences in the dialog that pops up
- click on the padlock
- enter the vagrant password
- allow the VMWare extension to run
- close the dialog

Once you have completed these steps, you may go back to the terminal where packer is running and press enter.


## Uploading the image to artifactory so that others may consume it

You need to inspect the upload-to-artifactory script, eventually modify the MacOS version based on which version of the OS you are installing.
Once you, have done that, run it.
The script has instructions on how to get an API key to upload the image to artifactory.
