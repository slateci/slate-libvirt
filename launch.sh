#!/bin/bash

#https://coreos.com/os/docs/latest/booting-with-libvirt.html

# vbox interferes
sudo systemctl stop vboxdrv
sudo modprobe -r vboxdrv vboxnetflt vboxpci vboxnetadp

sudo virsh destroy container-linux2
sudo virsh undefine container-linux2

sudo rm -f container-linux2.qcow
sudo qemu-img create -f qcow2 -b coreos_production_qemu_image.img container-linux2.qcow2

sudo virt-install --connect qemu:///system \
             --import \
             --name container-linux2 \
             --ram 1024 --vcpus 1 \
             --os-type=linux \
             --os-variant=virtio26 \
             --disk path=container-linux2.qcow2,format=qcow2,bus=virtio \
             --vnc --noautoconsole \
             --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=/home/lincolnb/slate-libvirt/config.ign"

sudo virsh console container-linux2
