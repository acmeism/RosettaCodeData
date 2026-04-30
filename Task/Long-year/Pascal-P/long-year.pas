program longyear(input, output);
  (* Long year *)
var
  s, e, y: integer;

  (* Weekday of y-12-31, 0 = Sunday *)
  function wd(y: integer): integer;
  begin
    wd := (y + y div 4 - y div 100 + y div 400) mod 7;
  end;

  (* true if and only if y is a long year *)
  function isly(y: integer): boolean;
  begin
    isly := (wd(y) = 4) or (wd(y - 1) = 3);
  end;

begin
  writeln('****     List of ISO long years     ****');
  write('Start year: ');
  read(s);
  write('End year: ');
  read(e);
  for y := s to e do
    if isly(y) then
      write(y: 5);
  writeln;
  (* readln; *)
end.
