module Logwatch
  class Window

    attr_reader :main, :messages, :top_sections, :stats

    def initialize
      Curses.init_screen
      Curses.curs_set 0 # invisible cursor
      Curses.noecho # don't echo keys entered

      @pos = 0

      half_height = Curses.lines / 2 - 2
      half_width = Curses.cols / 2 - 3

      @messages = Curses::Window.new(Curses.lines, half_width, 0, 0)
      @messages.keypad true # translate function keys to Curses::Key constants
      @messages.nodelay = true # don't block waiting for keyboard input with getch
      @messages.refresh

      @top_sections = Curses::Window.new(half_height, half_width, 0, half_width)
      @top_sections.refresh

      @stats = Curses::Window.new(half_height, half_width, half_height, half_width)
      @stats << "Stats:"
      @stats.refresh
    end

    def handle_keyboard_input
      case @messages.getch
      when Curses::Key::UP, 'k'
        @pos -= 1 unless @pos <= 0
        paint_messages!
      when Curses::Key::DOWN, 'j'
        @pos += 1 unless @pos >= @lines.count - 1
        paint_messages!
      when 'q'
        exit(0)
      end
    end

    def teardown
      Curses.close_screen
    end
  end
end

Logwatch::Window.new
