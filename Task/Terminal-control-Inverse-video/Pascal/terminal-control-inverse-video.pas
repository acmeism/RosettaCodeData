program InverseVideo;
{$LINKLIB tinfo}
uses
  ncurses;
begin
  initscr;
  attron(A_REVERSE);
  printw('reversed');
  attroff(A_REVERSE);
  printw(' normal');
  refresh;
  getch;
  endwin;
end.
