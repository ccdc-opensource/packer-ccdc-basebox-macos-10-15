#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/Users/vagrant}";
SSHD_CONFIG="/etc/ssh/sshd_config"

if [ "$CUSTOMISE_FOR_BUILDMACHINE" == "1" ]
then
    echo "Setting up allowed ssh keys for vagrant user on VMWare buildmachines"
    # only allow the following users in
    # Build provisioner from vagrant
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDSntcOn/0/zXMcLvp1Kt857Oq5aZ79LTqKpEdenQqr4KiD03KRx0Oxej+S/4w+gUsStEPHb/nzgM8PKEzIYK2jXbPiSeQfl9/6iZHEgX2+Tz6tLVLgAkNS92p8bSo+UStICSW5oHv3V3REixRRMTujX4iMpfcy48mJPf3YFr2aNBw/arH8TNERpuSXBAmYqGooA/UeR5dXnRZWYl5gZMb6Ncvb1POtLdP5A5IyGRAh0yHn51CEi4VrT5TDYkkgazu3oVRkxcPIHl+F/N/nUAR51e4dMygwtZAbDyPqfRD0R+wQNoSvsL1EU2HSq7iq4NEbBLdC1er0qztukGcPWPVB CCDC build machines ssh key 20200124" > $HOME_DIR/.ssh/authorized_keys
    # Claudio
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvG3aLzNKik2paExUWMH1p+fvrg9gw4Y4oNLYdnMIdrOqQtBhgvHVkXPCCrEcI+sCA0DzDy97J0m1Ucg8VVbyegXPpglAFES2VM+zzSr0O0fNWuBVE4vnLAWhlnhXhQ4jozG9Ig41mBPzFss0MVGqm4wS0IMpCV1LXDdf4jXVDKkUU/J65it7gKyrK1+d+DNECyfVtgbFfJ6PoeShQy7QtKooOnCLgOQDkfDE0RlhqNezw45dM5hzzjHEd0MLBHLmU2Tvu3ThNMGAYeCTJFBZh5Vwl/AzyjlyycfQhRU5a3jcWbR8el868dC+oEuj0bS/uasGR9IPOBWAhu6LX4hYj cbantaloukas@sys02" >> $HOME_DIR/.ssh/authorized_keys
    # Simon B.
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAvBUGjQF+pIwPBahChxiWg41POLY2+1+HKEircTTA1MNM1/gCfMsKprTEayeJPggPyez0s/xhvfLuPWDfBhAvtMjfQdYF8Qf8EHjGvQb51/O7ToodcFN2sidSOgqCMtK5aIfpG2VxHtTlW+5Ir8WJSFn0CeoxNaVTLeUzQBpapGs1rlnWEXWD558P5KVaAcwjj4bNMb9Ea4Lkjr/k4EkdfWwaWFNCm+Zk+77qa3PAr7xqFHEEujR2dVTWq6L+poh0RKyAeUsnDEBUkUdt3K/1bLX80o+Dat6fp4ZqQRXju4jvOu619Z6gsPqCZGYZSlZxw2H7zUFY9wquUWBO/5nQXw== rsa-key-20171204" >> $HOME_DIR/.ssh/authorized_keys
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2zSRBLswT6OOn1kR+SIx+Q6aLkAM/FpZVV1PiqPKkKiNUSy/RFkKFBKb4xkVdOi+Ic0UVMF7kpg8vTtp/JYGwCrw+5QznPt6r4HRt8svDr/sbQICjgI9ODelAduX+LGJMpSKaONEl+XkcmGxc4u7aJvLCGhQcSwW2csd02I9vt0Y+Y2prUffoxi0az9TsXlX1ZHF65TIdJ+Mp4J+f1/LIQ86G/6SZWcaYOkPsB0vNncXvwlCfJQCvZli6TKJQC9r8Xt1x63+TTHeNphy4OmAokFhpk8Ba30Clwc2rUWAbpVeaFovMzOoFrri5YdEx1jxhYUEgAdrehm/RtoYS/OBv sbowden@devlinux05" >> $HOME_DIR/.ssh/authorized_keys
    # Linlin
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkV9uJ7ZdXYsjxvZ7KAUHPTd6kcfaKaXarJOmcbEO/8o4tclNBz6bdriz4YtVutEWH1cs4nzrYDUwrsnhtXB25Bj6CqyFQdRCBDEngPFBTa6bWw1QU2Z4CwKGyt/ooz/boOVmY9IVl469UUMwsL0bNJm6sCKpnhIfuPA+PoN0JdypF/X36F9N6BFcyJRfrzIeY43/9542TXQPBAzqRuaHjNPnLB4F8GZezBEvFtoD8zk/9Sxr0nITgyHonn6olCUiUNK7SPM4qF3UAf+FyLTyT0yyOdOX8QbuC1N6sw0T0Dbhx/byc4EqMNEl8EAV+wq2X6pBNWiUWwTcHn5LxyMJMQ==" >> $HOME_DIR/.ssh/authorized_keys
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzJby2ZuK/+4UexdyUX5tNapz7k0SeWAbb6ih0ssWeUEJsT6RaK+NkQVaNVPqazPnG4K7AaLtV+uuoXcIqT5sp8jpz5NIar/r+X/k/9sV72NScv/MyuS8pW1CHAO5qYQVi3tAVDa6HL+UHg+kfVke4SfTpBLYnxRANHyn2BmmlSf+bG1Fs4TsG1hBRrrX3JFRKTxq7a+giHz6Z9dB/dGA9B2DXYAT6zwMvteh3I89++6OUXiFPNdHl4pQGfQNWkmf530Ri3qRt3C1geYjqGY2fmcfnkGUdD73+HwYgbnYdwSM28wkxdOkTXrY3jzaQ/zKKraiFAG78QE3MtD+EPN1B lxie@intranet01" >> $HOME_DIR/.ssh/authorized_keys
    echo "" >> $HOME_DIR/.ssh/authorized_keys
    
    chown -R vagrant $HOME_DIR/.ssh;
    chmod -R go-rwsx $HOME_DIR/.ssh;

    echo "Disabling password based ssh"

    # ensure that there is a trailing newline before attempting to concatenate
    sed -i -e '$a\' "$SSHD_CONFIG"

    CHALLENGERESPONSE="ChallengeResponseAuthentication no"
    if grep -q -E "^[[:space:]]*ChallengeResponseAuthentication" "$SSHD_CONFIG"; then
        sed -i "s/^\s*ChallengeResponseAuthentication.*/${CHALLENGERESPONSE}/" "$SSHD_CONFIG"
    else
        echo "$CHALLENGERESPONSE" >>"$SSHD_CONFIG"
    fi

    PASSWORDAUTH="PasswordAuthentication no"
    if grep -q -E "^[[:space:]]*PasswordAuthentication" "$SSHD_CONFIG"; then
        sed -i "s/^\s*PasswordAuthentication.*/${PASSWORDAUTH}/" "$SSHD_CONFIG"
    else
        echo "$PASSWORDAUTH" >>"$SSHD_CONFIG"
    fi

    USEPAM="UsePAM no"
    if grep -q -E "^[[:space:]]*UsePAM" "$SSHD_CONFIG"; then
        sed -i "s/^\s*UsePAM.*/${USEPAM}/" "$SSHD_CONFIG"
    else
        echo "$USEPAM" >>"$SSHD_CONFIG"
    fi
fi
