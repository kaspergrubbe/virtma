#!/usr/bin/env ruby
require 'curses'

def hex_to_4rgb(hex)
  m = hex.match /#(..)(..)(..)/
  [m[1].hex*4, m[2].hex*4, m[3].hex*4]
end

Pair = Struct.new(:fg_number, :bg_number)
PairChange = Struct.new(:number, :old_pair, :new_pair)
Colour = Struct.new(:number, :new_colour, :old_colour) # do
#   OFFSET = 17
#   def pairs
#     [number,
#     [number+offset
#     [number+offset*2
#   end
# end

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

  colors = [].tap do |it|
    it << Colour.new(2,  hex_to_4rgb('#FF0200'), Curses.color_content(2))
    it << Colour.new(3,  hex_to_4rgb('#1D9C44'), Curses.color_content(3))
    it << Colour.new(4,  hex_to_4rgb('#FA9D1B'), Curses.color_content(4))
    it << Colour.new(5,  hex_to_4rgb('#105FAE'), Curses.color_content(5))
    it << Colour.new(6,  hex_to_4rgb('#8E3BB1'), Curses.color_content(6))
    it << Colour.new(7,  hex_to_4rgb('#4C8BF5'), Curses.color_content(7))

    it << Colour.new(10, hex_to_4rgb('#F45614'), Curses.color_content(10))
    it << Colour.new(11, hex_to_4rgb('#8FBB33'), Curses.color_content(11))
    it << Colour.new(12, hex_to_4rgb('#FFCD46'), Curses.color_content(12))
    it << Colour.new(13, hex_to_4rgb('#0D8ACF'), Curses.color_content(13))
    it << Colour.new(15, hex_to_4rgb('#5CB8F5'), Curses.color_content(15))
  end

  colors.each do |colorchange|
    Curses.init_color(colorchange.number, *colorchange.new_colour)
  end

  (0..Curses.colors).each do |i|
    Curses.init_pair(i + 1, i, -1)
  end

  (0..255).each do |i|
    win.attron(Curses.color_pair(i))
    win.addstr(i.to_s)
    win.attroff(Curses.color_pair(i))
  end

  win.clear
  win.setpos(0,2)
  win.attron(Curses.color_pair(4) | Curses::A_REVERSE)
  win.addstr("Virtma.rb")
  win.attroff(Curses.color_pair(4))

  win.getch
  win.close
ensure
  colors.each do |colorchange|
    Curses.init_color(colorchange.number, *colorchange.old_colour)
  end
  Curses.close_screen
end

