program leapyear(output);

var
  y: integer;

  function isleap(y: integer): boolean;
  var
    res: boolean;
  begin
    res := false;
    if (y mod 4 = 0) and (y mod 100 <> 0) then
      res := true;
    if (y mod 400 = 0) then
      res := true;
    isleap := res;
  end;

begin
  for y := 1750 to 2022 do
    if isleap(y) then
      write(y: 5);
  writeln;
  (* readln; *)
end.
