# USAGE:
# path = "configs/test.rb"
# c = Configuration.new.setup!(path)

class Configuration
  def initialize
    @setup   = nil
    @command = nil
    @cleanup = nil
  end

  def setup(setup)
    @setup = setup
  end

  def command(command)
    @command = command
  end

  def cleanup(cleanup)
    @cleanup = cleanup
  end

  def setup!(path)
    eval(IO.read(path))
    self
  end

  def valid?
    true if @command
  end
end
