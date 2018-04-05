# USAGE:
# path = "configs/test.rb"
# c = Configuration.new.setup!(path)

class Configuration
  attr_reader :setup, :command, :cleanup, :zvols, :usb_devices

  def initialize
    @setup       = nil
    @command     = nil
    @cleanup     = nil
    @zvols       = []
    @usb_devices = []
  end

  def set_setup(setup)
    @setup = setup
  end

  def set_command(command)
    @command = command
  end

  def set_cleanup(cleanup)
    @cleanup = cleanup
  end

  def zvol(name, location)
    @zvols << [name, location]
  end

  def usb_device(name, usb_address, enabled)
    @usb_devices << [name, usb_address, enabled]
  end

  def setup!(path)
    eval(IO.read(path))
    self
  end

  def valid?
    true if @command
  end
end
