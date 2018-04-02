require_relative 'helpers'

module Virtma
  class WindowManager
    attr_reader :active_window, :screens

    def initialize(options, screens)
      @options = options
      @screens = screens
      @screens.each do |screen|
        screen.options        = options
        screen.window_manager = self
      end
      @active_window = @screens.first

      @active_window.focus
    end

    def next_window
      switch_window(:next)
    end

    def previous_window
      switch_window(:prev)
    end

    def redraw(window)
      window.clear

      window.setpos(0,2)
      window.addstr("Virtma.rb")

      @active_window.render(window)

      # Tabs
      menu_string_size = @screens.map{|m| "[#{m.menu_title}]"}.join(" ").size
      menu_y = window.maxy-1
      menu_x = window.maxx / 2 - menu_string_size / 2

      @screens.each do |screen|
        menu_title = "[#{screen.menu_title}]"
        effect = Curses::A_REVERSE if screen.focused?

        paint_effect(window, effect) do
          window.setpos(menu_y, menu_x)
          window.addstr(menu_title)
        end

        menu_x += menu_title.size
      end
    end

    private

    def switch_window(direction)
      if direction == :next
        next_window_position = @screens.index(@active_window) + 1
      elsif direction == :prev
        next_window_position = @screens.index(@active_window) - 1
      end

      next_window = @screens[next_window_position]

      if next_window && next_window_position >= 0
        @active_window.unfocus
        @active_window = next_window
        @active_window.focus
      end
    end
  end
end
