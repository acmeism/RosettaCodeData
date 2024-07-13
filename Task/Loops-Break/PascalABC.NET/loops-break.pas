begin
  while True do
  begin
    var x := Random(0,19);
    Print(x);
    if x = 10 then
      break;
    Print(Random(0,19));
  end;
end.
