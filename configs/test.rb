zvol 'Steam', '/dev/zvol/tank/steamdisk'
zvol 'Creative', '/dev/zvol/tank/creativedisk'
# raw 'Black and white 2', '/data/VMs/black_and_white2/qemu_vm.raw'

set_setup   'sleep 1'
#set_command 'ruby examples/ruby_loop.rb'
set_cleanup 'sleep 1'

usb_device 'Mouse',                                '1038:1361', true
usb_device 'Logitech Keyboard K120',               '046d:c31c', true
usb_device 'Steelseries headset',                  '1038:1211', true
usb_device 'Anker USB-hub',                        '0bda:5411', false
usb_device 'USB ethernet',                         '0b95:1790', false
usb_device 'Taranis',                              '0483:5710', false
usb_device 'RX Usb for Taranis',                   '0451:16a5', false
usb_device 'Apple, Inc. Ethernet Adapter [A1277]', '05ac:1402', false
usb_device 'Xbox 360 controller',                  '045e:028e', false
usb_device 'RØDE Microphone',                      '19f7:0003', false

# Consider using -monitor stdio for debugging and mounting .iso's etc.

set_command  <<~EOF
qemu-system-x86_64
-M q35
-serial none
-parallel none
-nodefaults
-nodefconfig
-enable-kvm
-name Windows
-cpu host,kvm=off,check,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_vendor_id=blarg
-smp sockets=1,cores=2,threads=2
-m 24576
-rtc base=localtime,driftfix=slew -global kvm-pit.lost_tick_policy=delay -no-hpet
-nographic
-device vfio-pci,host=01:00.0,multifunction=on
-device vfio-pci,host=01:00.1
-device vfio-pci,host=00:1f.6
-vga none
-device virtio-scsi-pci,id=scsi
-bios /usr/share/edk2.git/ovmf-x64/OVMF-pure-efi.fd
-drive file=/data/OSs/Win10_1709_EnglishInternational_x64.iso,id=isocd,index=0,format=raw,if=none
-device scsi-cd,drive=isocd
-cdrom /data/VMs/virtio-win-0.1.126.iso
EOF
