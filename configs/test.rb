zvol 'Steam', '/dev/zvol/tank/steamdisk'
zvol 'Creative', '/dev/zvol/tank/creativedisk'
# raw 'Black and white 2', '/data/VMs/black_and_white2/qemu_vm.raw'

set_setup   'sleep 1'
set_command 'ruby examples/ruby_loop.rb'
set_cleanup 'sleep 1'
