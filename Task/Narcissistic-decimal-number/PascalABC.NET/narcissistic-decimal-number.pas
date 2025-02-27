function narc(): sequence of integer;
begin
  var power := |0, 1, 2, 3, 4, 5, 6, 7, 8, 9|;
  var limit := 10;
  var x := 0;
  repeat
    if x >= limit then
    begin
      foreach var i in (0..9) do power[i] := power[i] * i;
      limit := limit * 10;
    end;
    var sum := 0;
    var xx := x;
    while (xx > 0) do
    begin
      sum := sum + power[xx mod 10];
      xx := (xx / 10).floor;
    end;
    if sum = x then yield x;
    x += 1;
  until false;
end;

begin
  narc.Take(25).println;
end.
