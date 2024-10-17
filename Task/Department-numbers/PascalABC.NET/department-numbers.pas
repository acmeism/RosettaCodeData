begin
  Writeln('Police  Fire    Sanitation');
  for var p := 2 to 6 step 2 do
  for var f := 1 to 7 do
  for var s := 1 to 7 do
    if (p <> f) and (f <> s) and (p <> s) and (p + f + s = 12) then
      Writeln($'{p,-8}{f,-8}{s,-8}');
end.
