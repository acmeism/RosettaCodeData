function isPrime(n: integer): boolean;
begin
  if (n mod 2 = 0) and (n > 2) then
  begin
    result := false;
    exit
  end;
  var i := 3;
  while i <= sqrt(n) do
  begin
    if n mod i = 0 then
    begin
      result := false;
      exit;
    end;
    i += 2;
  end;
  result := true;
end;

begin
  var count := 0; var n := 2; var m := 1;
  var sumP: int64 := 5; var sumC: int64 := 4;
  var numP := 3; var numC := 4;
  writeln( '            sum    primes  composites');

  repeat
    if sumC > sumP then
    begin
      repeat numP += 2 until isPrime(numP);
      sumP += numP;
      n += 1;
    end;
    if sumP > sumC then
    begin
      repeat numC += 1 until not isPrime(numC);
      sumC += numC;
      m += 1;
    end;
    if sumP = sumC then
    begin
      writeln(sumP:15, n:10, m:12);
      count += 1;
      repeat numC += 1 until not isPrime(numC);
      sumC += numC;
      m += 1;
    end
  until count >= 10
end.
