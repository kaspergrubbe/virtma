#!/usr/bin/env ruby
require 'curses'

begin
  Curses.init_screen

  Curses.start_color# if Curses.has_colors?
  Curses.use_default_colors

  Curses.nonl
  Curses.noecho # don't echo keys entered
  Curses.curs_set(0) # invisible cursor

  height = Curses.lines
  width  = Curses.cols

  win = Curses::Window.new(height, width, 0, 0)
  win.refresh

  # (0..Curses.colors).each_slice(4) do |ai|
  #   ai.each do |i|
  #     Curses.init_color(i, *colors.sample)
  #   end
  # end

  # (0..Curses.color_pairs).each do |i|
  #   Curses.init_pair(i, i, i)
  # end

  (0..Curses.color_pairs).each do |i|
    win.attron(Curses.color_pair(i))
    win.addstr(i.to_s)
    win.attroff(Curses.color_pair(i))
  end

  win.getch
  win.close
ensure
  #Curses.use_default_colors
  Curses.close_screen
end

