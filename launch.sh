#!/bin/bash

#https://coreos.com/os/docs/latest/booting-with-libvirt.html

# vbox interferes
sudo systemctl stop vboxdrv
sudo modprobe -r vboxdrv vboxnetflt vboxpci vboxnetadp

sudo virsh destroy slate
sudo virsh undefine slate

sudo rm -f slate.qcow
sudo qemu-img create -f qcow2 -b coreos_production_qemu_image.img slate.qcow2

sudo virt-install --connect qemu:///system \
             --import \
             --name slate \
             --ram 1024 --vcpus 1 \
             --os-type=linux \
             --os-variant=virtio26 \
             --disk path=slate.qcow2,format=qcow2,bus=virtio \
             --vnc --noautoconsole \
             --qemu-commandline="-fw_cfg name=opt/com.coreos/config,file=/home/lincolnb/slate-libvirt/config.ign"
             --print-xml > domain.xml

sed -ie 's|type="kvm"|type="kvm" xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0"|' domain.xml
sed -i "/<\/devices>/a <qemu:commandline>\n  <qemu:arg value='-fw_cfg'/>\n  <qemu:arg value='name=opt/com.coreos/config,file=config.ign'/>\n</qemu:commandline>" domain.xml


sudo virsh console slate
