# slate-libvirt
Libvirt-based SLATE image 

# To run:
You'll need to have qemu and qemu-kvm installed. This has been tested on qemu-kvm-ev-2.10.0 on CentoS 7.

## Install Qemu
This may work on stock qemu/kvm, but you can install the CentOS Enterprise Virtualization repo from here:
```
# yum install centos-release-qemu-ev
```

Then:
```
yum install qemu-kvm-ev libvirt
```

Otherwise, install the `qemu-kvm` package if `qemu-kvm-ev` is not available. You will probably need to start libvirt as well:
```
systemctl start libvirtd
```

## Define a SLATE "host-only" network
In libvirt, you'll need to create an additional network interface for SLATE, provided by `network.xml` in this repo:
```
# virsh net-define network.xml
# virsh net-start slate
# virsh net-autostart slate
```

## Download the CoreOS components
You'll need a CoreOS image (I used the beta channel) and the CoreOS config transpiler (ct) to convert the config from YAML to Ignition JSON format
Simply run `download.sh` or download and bunzip whatever version you would like.
```
$ ./download.sh
````

## Edit the config.yaml and transpile it
The image is set to auto-login as user 'core' on the console, but you'll probably want an SSH key in there as well to SSH to the VM.
Edit config.yaml to your liking, and then run it through the transpiler:
```
./ct -in-file config.yaml --files-dir ignition/ > config.ign
```

Finally, you'll want to edit `launch.sh` and replace the line that says `/home/lincolnb/slate-libvirt/config.ign` with the actual path of your `config.ign` file generated in the previous step, and then run it.
```
$ ./launch.sh
```

Note the command above has a ton of `sudo` statements so you'll probably want to either run it as root or have passwordless sudo setup.
