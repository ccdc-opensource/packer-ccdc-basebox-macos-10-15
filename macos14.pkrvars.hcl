iso_filename = "macos-iso/14.0-23A5312d.iso"
vagrant_box = "ccdc-basebox/macos-14"
macos_version = "14.0"
output_directory = "output/macos14/"
boot_command = [
    "<enter><wait10s>",
    "<LeftSuperOn><LeftShiftOn>T<LeftSuperOff><LeftShiftOff><wait5s>",
    "curl -o /var/root/bootstrap.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh<enter>",
    "chmod +x /var/root/bootstrap.sh<enter>",
    "PACKAGE_HTTP_SERVER=http://{{ .HTTPIP }}:{{ .HTTPPort}} /var/root/bootstrap.sh<enter>"
]
user_username = "packer"
user_password = "packer"
