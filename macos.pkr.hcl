packer {
  required_version = ">= 1.7.0"
  required_plugins {
    ansible = {
      version = ">= 1.1.0"
      source: "github.com/hashicorp/ansible"
    }
    vmware = {
      version = ">= 1.0.9"
      source  = "github.com/hashicorp/vmware"
    }
    vsphere = {
      version = ">= 1.2.1"
      source: "github.com/hashicorp/vsphere"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.0.3"
    }
  }
}

variable "iso_filename" { type = string }
variable "vagrant_box" { type = string }
variable "macos_version" { type = string }

variable "vmware_center_cluster_name" {
  type    = string
  default = "${env("VMWARECENTER_CLUSTER_NAME")}"
}

variable "vmware_center_datacenter" {
  type    = string
  default = "${env("VMWARECENTER_DATACENTER")}"
}

variable "vmware_center_datastore" {
  type    = string
  default = "${env("VMWARECENTER_DATASTORE")}"
}

variable "vmware_center_esxi_host" {
  type    = string
  default = "${env("VMWARECENTER_ESXI_HOST")}"
}

variable "vmware_center_host" {
  type    = string
  default = "${env("VMWARECENTER_HOST")}"
}

variable "vmware_center_password" {
  type      = string
  default   = "${env("VMWARECENTER_PASSWORD")}"
  sensitive = true
}

variable "vmware_center_username" {
  type    = string
  default = "${env("VMWARECENTER_USERNAME")}"
}

variable "vmware_center_vm_folder" {
  type    = string
  default = "${env("VMWARECENTER_VM_FOLDER")}"
}

variable "vmware_center_vm_name" {
  type    = string
  default = "${env("VMWARECENTER_VM_NAME")}"
}

variable "vmware_center_vm_network" {
  type    = string
  default = "${env("VMWARECENTER_VM_NETWORK")}"
}

# Set this to DeveloperSeed if you want prerelease software updates
variable "seeding_program" {
  type = string
  default =  "none"
}

variable "cpu_count" {
  type = number
  default =  "2"
}
variable "ram_gb" {
  type = number
  default =  "4"
}
variable "disk_size" {
  type = string
  default =  "300000"
}
variable "board_id" {
  type = string
  default =  "Mac-27AD2F918AE68F61"
}
variable "hw_model" {
  type = string
  default =  "MacPro7,1"
}
variable "serial_number" {
  type = string
  default =  "M00000000001"
}

variable "iso_file_checksum" {
  type = string
  default = "file:macos-iso/shasums.txt"
}
variable "user_password" {
  type = string
  default = "vagrant"
}
variable "user_username" {
  type = string
  default = "vagrant"
}
variable "artifactory_api_key" {
  type = string
  default = env("ARTIFACTORY_API_KEY")
}
variable "artifactory_username" {
  type = string
  default =  env("USER")
}
variable "output_directory" {
  type = string
  default =  "${env("PWD")}/output/"
}
variable "boot_command" {
  type = list(string)
  default = [
    "<enter><wait10s>",
    "<leftSuperon><f5><leftSuperoff>",
    "<leftCtrlon><f2><leftCtrloff>",
    "u<down><down><down>",
    "<enter>",
    "<leftSuperon><f5><leftSuperoff><wait10>",
    "<leftCtrlon><f2><leftCtrloff>",
    "w<down><down>",
    "<enter>",
    "curl -o /var/root/bootstrap.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh<enter>",
    "chmod +x /var/root/bootstrap.sh<enter>",
    "PACKAGE_HTTP_SERVER=http://{{ .HTTPIP }}:{{ .HTTPPort}} /var/root/bootstrap.sh<enter>"
  ]
}
variable "boot_key_interval_iso" {
  type = string
  default =  "150ms"
}
variable "boot_wait_iso" {
  type = string
  default =  "3m"
}
variable "boot_keygroup_interval_iso" {
  type = string
  default =  "4s"
}
variable "bootstrapper_script" {
  type = list(string)
  default =  ["sw_vers"]
}
variable "headless" {
  type = bool
  default =  false
}
variable "vnc_bind_address" {
  type = string
  default =  "127.0.0.1"
}
variable "vnc_port_min" {
  type = string
  default =  "5900"
}
variable "vnc_port_max" {
  type = string
  default =  "6000"
}
variable "vnc_disable_password" {
  type = bool
  default =  false
}
variable "remove_packer_user" {
  type = bool
  default =  true
}
variable "new_username" {
  type = string
  default =  "vagrant"
}
variable "new_password" {
  type = string
  default =  "vagrant"
}
variable "new_ssh_key" {
  type = string
  default =  ""
}
variable "new_hostname" {
  type = string
  default =  "macosvm"
}

# VMware desktop build
source "vmware-iso" "macOS" {
  iso_url              = "${var.iso_filename}"
  iso_checksum         = "${var.iso_file_checksum}"
  vnc_bind_address     = "${var.vnc_bind_address}"
  vnc_disable_password = "${var.vnc_disable_password}"
  vnc_port_min         = "${var.vnc_port_min}"
  vnc_port_max         = "${var.vnc_port_max}"
  display_name         = "ccdc-basebox-macos-${var.macos_version}.${formatdate("YYYYMMDD", timestamp())}"
  vm_name              = "ccdc-basebox-macos-${var.macos_version}.${formatdate("YYYYMMDD", timestamp())}"
  vmdk_name            = "ccdc-basebox-macos-${var.macos_version}.${formatdate("YYYYMMDD", timestamp())}"
  ssh_username         = "${var.user_username}"
  ssh_password         = "${var.user_password}"
  shutdown_command     = "sudo shutdown -h now"
  output_directory     = "${var.output_directory}"
  guest_os_type        = "darwin22-64"
  cdrom_adapter_type   = "sata"
  disk_size            = "${var.disk_size}"
  disk_adapter_type    = "nvme"
  http_directory       = "http"
  network_adapter_type = "vmxnet3"
  disk_type_id         = "0"
  ssh_timeout          = "12h"
  usb                  = "true"
  version              = "19"
  cpus                 = var.cpu_count
  cores                = var.cpu_count
  memory               = var.ram_gb * 1024
  vmx_data = {
    "gui.fitGuestUsingNativeDisplayResolution" = "FALSE"
    "tools.upgrade.policy"                     = "manual"
    "smc.present"                              = "TRUE"
    "smbios.restrictSerialCharset"             = "TRUE"
    "ulm.disableMitigations"                   = "TRUE"
    "ich7m.present"                            = "TRUE"
    "hw.model"                                 = "${var.hw_model}"
    "hw.model.reflectHost"                     = "FALSE"
    "smbios.reflectHost"                       = "FALSE"
    "board-id"                                 = "${var.board_id}"
    "serialNumber"                             = "${var.serial_number}"
    "serialNumber.reflectHost"                 = "FALSE"
    "SMBIOS.use12CharSerialNumber"             = "TRUE"
    "usb_xhci:4.deviceType"                    = "hid"
    "usb_xhci:4.parent"                        = "-1"
    "usb_xhci:4.port"                          = "4"
    "usb_xhci:4.present"                       = "TRUE"
    "usb_xhci:6.deviceType"                    = "hub"
    "usb_xhci:6.parent"                        = "-1"
    "usb_xhci:6.port"                          = "6"
    "usb_xhci:6.present"                       = "TRUE"
    "usb_xhci:6.speed"                         = "2"
    "usb_xhci:7.deviceType"                    = "hub"
    "usb_xhci:7.parent"                        = "-1"
    "usb_xhci:7.port"                          = "7"
    "usb_xhci:7.present"                       = "TRUE"
    "usb_xhci:7.speed"                         = "4"
    "usb_xhci.pciSlotNumber"                   = "192"
    "usb_xhci.present"                         = "TRUE"
    "hgfs.linkRootShare"                       = "FALSE"
  }
  vmx_data_post = {
    "sata0:0.autodetect"     = "TRUE"
    "sata0:0.deviceType"     = "cdrom-raw"
    "sata0:0.fileName"       = "auto detect"
    "sata0:0.startConnected" = "FALSE"
    "sata0:0.present"        = "TRUE"
    "vhv.enable"             = "TRUE"
    "svga.present"                             = "FALSE"
    "appleGPU0.present"                        = "TRUE"
  }
  boot_wait              = var.boot_wait_iso
  boot_key_interval      = var.boot_key_interval_iso
  boot_keygroup_interval = var.boot_keygroup_interval_iso
  boot_command = var.boot_command
}

# VMware VSphere build
source "vsphere-iso" "macOS" {
  boot_wait              = var.boot_wait_iso
  // boot_key_interval      = var.boot_key_interval_iso
  boot_keygroup_interval = var.boot_keygroup_interval_iso
  boot_command = [
    "<enter><wait10s>",
    "<leftSuperon><wait2s><f5><wait2s><leftSuperoff>",
    "<leftCtrlon><wait2s><f2><wait2s><leftCtrloff>",
    "u<down><down><down>",
    "<enter>",
    "<leftSuperon><wait2s><f5><wait2s><leftSuperoff><wait10>",
    "<leftCtrlon><wait2s><f2><wait2s><leftCtrloff>",
    "w<down><down>",
    "<enter>",
    "curl -o /var/root/bootstrap.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh<enter>",
    "chmod +x /var/root/bootstrap.sh<enter>",
    "PACKAGE_HTTP_SERVER=http://{{ .HTTPIP }}:{{ .HTTPPort}} /var/root/bootstrap.sh<enter>"
  ]
  convert_to_template  = true
  vm_version           = 19
  CPUs                 = "${var.cpu_count}"
  disk_controller_type = ["nvme"]
  storage {
      disk_size = "${var.disk_size}"
      disk_thin_provisioned = true
      disk_controller_index = 0
  }
  firmware             = "efi"
  RAM                  = var.ram_gb * 1024
  network_adapters {
      network = "${var.vmware_center_vm_network}"
      network_card = "vmxnet3"
  }
  video_ram            = 128 * 1024
  guest_os_type        = "darwin21_64Guest"
  shutdown_command     = "echo 'vagrant' | sudo -S /sbin/halt -h -p"

  configuration_parameters = {
    "tools.upgrade.policy": "manual",
    "smc.present": "TRUE",
    "smc.version": "0",
    "smbios.restrictSerialCharset": "TRUE",
    "ulm.disableMitigations": "TRUE",
    "ich7m.present": "TRUE",
    "chipset.motherboardLayout": "acpi",
    "hw.model": "${var.hw_model}",
    "hw.model.reflectHost": "FALSE",
    "smbios.reflectHost": "FALSE",
    "board-id": "${var.board_id}",
    "serialNumber": "${var.serial_number}",
    "serialNumber.reflectHost": "FALSE",
    "SMBIOS.use12CharSerialNumber": "TRUE",
    "usb_xhci:4.deviceType": "hid",
    "usb_xhci:4.parent": "-1",
    "usb_xhci:4.port": "4",
    "usb_xhci:4.present": "TRUE",
    "usb_xhci:6.deviceType": "hub",
    "usb_xhci:6.parent": "-1",
    "usb_xhci:6.port": "6",
    "usb_xhci:6.present": "TRUE",
    "usb_xhci:6.speed": "2",
    "usb_xhci:7.deviceType": "hub",
    "usb_xhci:7.parent": "-1",
    "usb_xhci:7.port": "7",
    "usb_xhci:7.present": "TRUE",
    "usb_xhci:7.speed": "4",
    "usb_xhci.pciSlotNumber": "192",
    "usb_xhci.present": "TRUE",
    "hgfs.linkRootShare": "FALSE",
    "vhv.enable": "TRUE",
    "svga.present": "TRUE",
    "appleGPU0.present": "FALSE"
  }

  cdrom_type           = "sata"
  remove_cdrom         = true
  usb_controller       = ["xhci"]
  // vTPM                 = true
  http_port_max        = 65535
  http_port_min        = 49152
  http_directory       = "http"

  host                 = "${var.vmware_center_esxi_host}"
  ssh_port             = 22
  ssh_timeout          = "12h"
  ip_wait_timeout      = "1h"
  ssh_username         = "${var.user_username}"
  ssh_password         = "${var.user_password}"
  vm_name              = "ccdc-basebox-macos-${var.macos_version}.${formatdate("YYYYMMDD", timestamp())}"
  vcenter_server       = "${var.vmware_center_host}"
  username             = "${var.vmware_center_username}"
  password             = "${var.vmware_center_password}"
  insecure_connection  = false
  datacenter           = "${var.vmware_center_datacenter}"
  datastore            = "${var.vmware_center_datastore}"
  cluster              = "${var.vmware_center_cluster_name}"
  network_adapters {
      network = "${var.vmware_center_vm_network}"
      network_card = "vmxnet3"
  }
}

# Base build
build {
  name = "base"
  sources = [
    "sources.vmware-iso.macOS",
    "sources.vsphere-iso.macOS"
  ]

  # Enable passwordless sudo
  provisioner "shell" {
    inline = ["echo '%admin ALL = (ALL) NOPASSWD: ALL' | sudo tee /private/etc/sudoers.d/passwordless-sudo.conf"]
  }

  # Install Homebrew
  provisioner "shell" {
    inline = [
      "curl -fsSLo /tmp/homebrew.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh",
      "/bin/bash /tmp/homebrew.sh",
      "rm /tmp/homebrew.sh"
    ]
  }

  provisioner "ansible" {
    playbook_file = "./ansible_provisioning/playbook.yaml"
    galaxy_file = "./ansible_provisioning/requirements.yaml"
    roles_path = "./ansible_provisioning/roles"
    galaxy_force_install = true
    user            = "packer"
    use_proxy       = false
    extra_arguments = [
      // "-vvv",
      "-e", "ansible_ssh_password=packer",
      "--ssh-extra-args='-o UserKnownHostsFile=/dev/null'"
    ]
  }

  provisioner "breakpoint" {
    disable = false
    note    = "Please use the macOS GUI to allow the VMware Tools extensions to be loaded and reboot the system."
  }

  post-processors {

    post-processor "vagrant" {
      except = ["vsphere-iso.macOS"]
      output = "${var.output_directory}/${ var.vagrant_box }.${ replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop") }.box"
    }

    # Once box has been created, upload it to Artifactory
    post-processor "shell-local" {
      except = ["vsphere-iso.macOS"]
      command = join(" ", [
        "jf rt upload",
        "--target-props \"box_name=${ var.vagrant_box };box_provider=${replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop")};box_version=${ formatdate("YYYYMMDD", timestamp()) }.0\"",
        "--retries 10",
        "--access-token ${ var.artifactory_api_key }",
        "--user ${ var.artifactory_username }",
        "--url \"https://artifactory.ccdc.cam.ac.uk/artifactory\"",
        "${var.output_directory}/${var.vagrant_box}.${replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop")}.box",
        "ccdc-vagrant-repo/${var.vagrant_box}.${formatdate("YYYYMMDD", timestamp())}.0.${replace(replace(replace(source.type, "-iso", ""), "hyper-v", "hyperv"), "vmware", "vmware_desktop")}.box"
      ])
    }
  }
}
