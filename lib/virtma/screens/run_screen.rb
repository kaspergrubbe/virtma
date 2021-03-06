require 'childprocess'

module Virtma::Screens
  class RunScreen < BaseScreen
    def initialize(options)
      super

      @process      = nil
      @process_log  = []
      @process_pipe = nil
    end

    def menu_title
      'Run'
    end

    def render(window)
      selected_vm_string = "Selected VM: "
      paint_effect(window, Curses::A_BOLD) do
        window.setpos(2,2)
        window.addstr(selected_vm_string)
      end

      window.setpos(2,2+selected_vm_string.size)
      window.addstr(active_vm.name)

      paint_effect(window, Curses::A_BOLD) do
        window.setpos(4,2)
        window.addstr("Selected USBs:")
      end

      last_usb_line = 5
      active_usb_devices.to_enum.with_index(last_usb_line) do |usb_device, index|
        window.setpos(index,4)
        window.addstr("#{usb_device.name} <#{usb_device.address}>")
        last_usb_line = index
      end

      if @process && @process.alive?
        paint_effect(window, Curses.color_pair(197) | Curses::A_REVERSE) do
          window.setpos(last_usb_line+2,2)
          window.addstr("Kill VM!")
        end

        begin
          write_log(@process_pipe.readline_nonblock)
          changed!
        rescue IO::EAGAINWaitReadable
        end
      else
        paint_effect(window, Curses.color_pair(16) | Curses::A_REVERSE) do
          window.setpos(last_usb_line+2,2)
          window.addstr("Launch VM!")
        end
      end

      log_height = last_usb_line+2+2..window.maxy-2
      log_lines = log_height.last - log_height.first

      @process_log.last(log_lines).to_enum.with_index(log_height.first).each do |log_line, index|
        window.setpos(index,2)
        window.addstr("#{log_line}")
      end
    end

    def toggle
      super

      if @process && @process.alive?
        begin
          write_log("Trying to kill nicely")
          @process.poll_for_exit(15)
        rescue ChildProcess::TimeoutError
          write_log("Trying to kill harshly")
          @process.stop
        end

        if @process.alive?
          # This shouldn't happen
          write_log("Process #{@process.pid} _NOT_ killed!")
        else
          write_log("Process #{@process.pid} dead !")
        end
      else
        compile_command

        @process_pipe, wr = IO.pipe
        @process = ChildProcess.build(compile_command)
        @process.io.stdout = wr
        @process.start
        wr.close

        write_log("Started!")
      end

      changed!
    end

    private

    def write_log(message)
      date_format = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      @process_log << "[#{date_format}] #{message}"
    end

    def active_vm
      window_manager.screens.select{|screen| screen.class == Virtma::Screens::VmScreen}.first.active_vm.first
    end

    def active_usb_devices
      window_manager.screens.select{|screen| screen.class == Virtma::Screens::UsbScreen}.first.active_usb_devices
    end

    def compile_command
      usb_lines = active_usb_devices.map do |usb_device|
        "-usb -usbdevice host:#{usb_device.address}"
      end.join("\n")

      drive_line = "-drive id=disk0,file=#{active_vm.disk_location},if=virtio,format=raw,cache=none"

      command = <<~EOF
        #{@options[:configuration].command}
        #{drive_line}
        #{usb_lines}
      EOF
      command.squeeze("\n").split("\n").join(" ")
    end
  end
end
