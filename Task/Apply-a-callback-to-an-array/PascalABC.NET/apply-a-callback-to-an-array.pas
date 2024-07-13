begin
  var a := Arr(1..10);
  a := a.Select(x -> x * x).ToArray;
  a.ForEach(x -> Print(x));
end.
