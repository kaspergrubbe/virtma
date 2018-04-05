# USAGE:
# path = "configs/test.rb"
# c = Configuration.new.setup!(path)

class Configuration
  attr_reader :setup, :command, :cleanup, :zvols

  def initialize
    @setup   = nil
    @command = nil
    @cleanup = nil
    @zvols   = []
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

  def setup!(path)
    eval(IO.read(path))
    self
  end

  def valid?
    true if @command
  end
end
