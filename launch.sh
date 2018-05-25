#!/bin/bash

#https://coreos.com/os/docs/latest/booting-with-libvirt.html

# stop any running vbox
#sudo systemctl stop vboxdrv
#sudo modprobe -r vboxdrv vboxnetflt vboxpci vboxnetadp

###### need this interface added
# sudo virsh net-define network.xml
# sudo virsh net-start slate
# sudo virsh net-autostart slate

sudo virsh destroy slate
sudo virsh undefine slate

sudo rm -f slate.qcow
sudo qemu-img create -f qcow2 -b coreos_production_qemu_image.img slate.qcow2

#virsh net-update --network "default" add-last ip-dhcp-host \
#    --xml "<host mac='${mac}' ip='${ip}' />" \
#    --live --config


sudo virt-install --connect qemu:///system \
             --import \
             --name slate \
             --ram 4096 --vcpus 2 \
             --os-type=linux \
             --os-variant=virtio26 \
             --disk path=slate.qcow2,format=qcow2,bus=virtio \
             --mac="52:54:00:5c:a1:ec" \
             --vnc --noautoconsole \
             --network network="default" \
             --print-xml > domain.xml

sed -ie 's|type="kvm"|type="kvm" xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0"|' domain.xml
sed -i "/<\/devices>/a <qemu:commandline>\n  <qemu:arg value='-fw_cfg'/>\n  <qemu:arg value='name=opt/com.coreos/config,file=/home/lincolnb/slate-libvirt/config.ign'/>\n</qemu:commandline>" domain.xml

sudo virsh define domain.xml

# add an interface on the 'slate' network 
# this is the equivalent of VBox host-only
sudo virsh attach-interface --domain slate --type network --mac "52:54:00:5c:a1:ed" --source slate --config

sudo virsh start slate

sudo virsh console slate
