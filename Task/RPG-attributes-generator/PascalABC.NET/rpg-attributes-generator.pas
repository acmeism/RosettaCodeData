begin
  repeat
    var a := ArrGen(6, i -> ArrRandomInteger(4,1,6).Order.Skip(1).Sum);
    var cnt := a.Count(x -> x >= 15);
    if (a.Sum < 75) or (cnt < 2) then
      continue;
    a.Println;
    Println($'Sum: {a.Sum}. Count of elements >= 15: {cnt}');
    break;
  until False;
end.
