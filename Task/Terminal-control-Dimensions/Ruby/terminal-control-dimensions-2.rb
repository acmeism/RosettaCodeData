require 'curses'

begin
  Curses.init_screen

  r, c = Curses.lines, Curses.cols

  Curses.setpos r / 2, 0
  Curses.addstr "#{r} rows by #{c} columns".center(c)
  Curses.getch
ensure
  Curses.close_screen
end
