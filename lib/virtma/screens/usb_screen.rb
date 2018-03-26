module Virtma::Screens
  class UsbScreen < BaseScreen
    UsbDevice = Struct.new(:name, :address, :toggled)

    def initialize
      super

      @position = 0
      @usb_devices = [].tap do |it|
        it << UsbDevice.new('Mouse', '1038:1361', true)
        it << UsbDevice.new('Logitech Keyboard K120', '046d:c31c', true)
        it << UsbDevice.new('Steelseries headset','1038:1211', true)
        it << UsbDevice.new('Anker USB-hub', '0bda:5411', false)
        it << UsbDevice.new('USB ethernet', '0b95:1790', false)
        it << UsbDevice.new('Taranis', '0483:5710', false)
        it << UsbDevice.new('RX Usb for Taranis', '0451:16a5', false)
        it << UsbDevice.new('Apple, Inc. Ethernet Adapter [A1277]', '05ac:1402', false)
        it << UsbDevice.new('Xbox 360 controller', '045e:028e', false)
        it << UsbDevice.new('RØDE Microphone', '19f7:0003', false)
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
