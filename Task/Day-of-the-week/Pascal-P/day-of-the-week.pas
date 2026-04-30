program dayoftheweek(output);

var
  y: integer;

  function dayofweek(y, m, d: integer): integer;
    (* Sunday = 0, Saturday = 6 *)
  var
    z: integer;
  begin
    if m < 3 then
    begin
      y := y - 1;
      m := m + 12;
    end;
    z := y + (y div 4) - (y div 100) + (y div 400);
    dayofweek := (z + d + (153 * m + 8) div 5) mod 7;
  end;

begin
  for y := 2007 to 2122 do
    if dayofweek(y, 12, 25) = 0 then
      write(y);
  writeln
end.
