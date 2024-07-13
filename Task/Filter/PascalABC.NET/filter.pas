begin
  var a := Arr(1..10);
  var even := a.Where(x -> x mod 2 = 0);
  even.Print
end.
