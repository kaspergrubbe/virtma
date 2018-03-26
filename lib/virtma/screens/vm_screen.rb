module Virtma::Screens
  class VmScreen < BaseScreen
    VM = Struct.new(:name, :disk_location, :toggled)

    def initialize
      @position = 0
      @vms = [
        VM.new('Steam', '/dev/zvol/tank/steamdisk', false),
        VM.new('Creative', '/dev/zvol/tank/creativedisk', false),
        VM.new('Black and white 2', '/data/VMs/black_and_white2/qemu_vm.raw', false),
      ]

      # Default the first one to be toggled
      @vms.first.toggled = true
    end

    def active_vm
      @vms.select{|vm| vm.toggled}
    end

    def menu_title
      'VMs'
    end

    def render(window)
      @vms.each_with_index do |vm, index|
        window.setpos(index+1,2)

        toggle_state = if(vm.toggled)
          'x'
        else
          ' '
        end

        vm_string = "[#{toggle_state}] #{vm.name}"
        fill = " " * (window.maxx - vm_string.size - 2 * 2)
        vm_string = "#{vm_string}#{fill}"

        if @position == index
          paint_effect(window, Curses::A_REVERSE) do
            window.addstr(vm_string)
          end
        else
          window.addstr(vm_string)
        end
      end
    end

    def up
      super

      unless @position <= 0
        @position -= 1
        changed!
      end
    end

    def down
      super

      unless @position >= @vms.count - 1
        @position += 1
        changed!
      end
    end

    def toggle
      super

      @vms.each do |vm|
        if vm == @vms[@position]
          vm.toggled = true
        else
          vm.toggled = false
        end
      end

      changed!
    end
  end
end
