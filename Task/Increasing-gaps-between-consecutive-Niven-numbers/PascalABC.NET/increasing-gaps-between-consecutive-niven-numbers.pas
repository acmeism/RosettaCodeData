function digitsSum(n, sum: int64): int64;
begin
  result := sum + 1;
  while (n > 0) and (n mod 10 = 0) do
  begin
    result -= 9;
    n := n div 10;
  end;
end;

begin
  var niven: int64 := 0;
  var gap: int64 := 0;
  var sum: int64 := 0;
  var nivenIndex: int64 := 0;
  var previous: int64 := 1;
  var gapIndex: int64 := 1;

  println('Gap index  Gap  Niven index  Niven number');

  while gapIndex <= 32 do
  begin
    niven += 1;
    sum := digitsSum(niven, sum);
    if niven mod sum = 0 then
    begin
      if niven > previous + gap then
      begin
        gap := niven - previous;
        writeln(gapIndex:9, gap:5, nivenIndex:13, previous:14);
        gapIndex += 1;
      end;
      previous := niven;
      nivenIndex += 1;
    end;
  end;
end.
