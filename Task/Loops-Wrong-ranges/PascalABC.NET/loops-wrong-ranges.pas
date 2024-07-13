procedure DisplayRange(first, last, step: integer);
begin
  Print($'({first,2}, {last,2}, {step,2}):  ');
  if step = 0 then
    Println('not allowed')
  else Println(Range(first, last, step));
end;

begin
  var ranges := |(-2, 2, 1), (-2, 2, 0), (-2, 2, -1),
                 (-2, 2, 10), (2, -2, 1), (2, 2, 1),
                 (2, 2, -1), (2, 2, 0), (0, 0, 0)|;
  foreach var (f, l, s) in ranges do
    DisplayRange(f,l,s);
end.
