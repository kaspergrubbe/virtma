#!/usr/bin/env ruby

require 'curses'

begin
  Curses.init_screen

  Curses.start_color# if Curses.has_colors?
  Curses.use_default_colors

  Curses.nonl
  Curses.noecho # don't echo keys entered
  Curses.curs_set(0) # invisible cursor

  half_height = Curses.lines
  half_width = Curses.cols

  win = Curses::Window.new(half_height, half_width, 0,0)
  win.refresh

  (0..Curses.colors).each do |i|
    Curses.init_pair(i + 1, i, -1)
  end

  (0..255).each do |i|
    win.attron(Curses.color_pair(i))
    win.addstr(i.to_s)
    win.attroff(Curses.color_pair(i))
  end

  win.getch

  win.close
ensure
  Curses.close_screen
end

