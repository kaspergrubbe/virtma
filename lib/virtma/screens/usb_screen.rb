module Virtma::Screens
  class UsbScreen < BaseScreen
    UsbDevice = Struct.new(:name, :address, :toggled)

    def initialize(options)
      super

      @position = 0
      @usb_devices = [].tap do |it|
        @options[:configuration].usb_devices.each do |name, usb_address, enabled|
          it << UsbDevice.new(name, usb_address, enabled)
        end
      end
    end

    def active_usb_devices
      @usb_devices.select{|usb_device| usb_device.toggled}
    end

    def render(window)
      @usb_devices.each_with_index do |device, index|
        window.setpos(index+1,2)

        toggle_state = if(device.toggled)
          'x'
        else
          ' '
        end

        usb_device_string = "[#{toggle_state}] #{device.name}"
        fill = " " * (window.maxx - usb_device_string.size - 2 * 2)
        usb_device_string = "#{usb_device_string}#{fill}"

        if @position == index
          paint_effect(window, Curses::A_REVERSE) do
            window.addstr(usb_device_string)
          end
        else
          window.addstr(usb_device_string)
        end
      end
    end

    def menu_title
      'USB-devices'
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

      unless @position >= @usb_devices.count - 1
        @position += 1
        changed!
      end
    end

    def toggle
      super

      if @usb_devices[@position].toggled
        @usb_devices[@position].toggled = false
        changed!
      else
        @usb_devices[@position].toggled = true
        changed!
      end
    end
  end
end
