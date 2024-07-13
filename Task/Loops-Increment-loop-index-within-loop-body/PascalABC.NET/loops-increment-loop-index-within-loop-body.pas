function IsPrime(n: BigInteger)
  := (2..n.Sqrt.Round).All(x -> n mod x <> 0);

begin
  var i := 1;
  var n := 42bi;
  while i <= 42 do
  begin
    if IsPrime(n) then
    begin
      Println($'{i,3} {n,15}');
      i += 1;
      n += n - 1;
    end;
    n += 1;
  end;
end.
