#!/usr/bin/env ruby
require 'curses'

def hex_to_rgb(hex)
  m = hex.match /#(..)(..)(..)/
  [m[1].hex*4, m[2].hex*4, m[3].hex*4]
end

colors = [
  '#4B8BBE',
  '#306998',
  '#FFE873',
  '#FFD43B',
  '#646464',
].map{|c| hex_to_rgb(c)}

begin
  Curses.init_screen

  Curses.start_color# if Curses.has_colors?
  #Curses.use_default_colors

  Curses.nonl
  Curses.noecho # don't echo keys entered
  Curses.curs_set(0) # invisible cursor

  height = Curses.lines
  width  = Curses.cols

  win = Curses::Window.new(height, width, 0, 0)
  win.refresh

  (0..Curses.colors).each_slice(4) do |ai|
    ai.each do |i|
      Curses.init_color(i, *colors.sample)
    end
  end

  (0..Curses.color_pairs).each do |i|
    Curses.init_pair(i, i, -1)
  end

  (0..Curses.color_pairs).each do |i|
    win.attron(Curses.color_pair(i))
    win.addstr(i.to_s)
    win.attroff(Curses.color_pair(i))
  end

  win.getch
  win.close
ensure
  Curses.use_default_colors
  Curses.close_screen
end

