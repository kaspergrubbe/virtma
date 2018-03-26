# Example:
# paint_effect(window, Curses.color_pair(5) | Curses::A_REVERSE) do
#   window.addstr(menu_string)
# end

def paint_effect(window, attributes)
  window.attron(attributes) if attributes
  yield
  window.attroff(attributes) if attributes
end
