function binomial(n, k: integer): biginteger;
begin
  result := 1bi;
  for var i := 1 to k do
    result := result * (n - i + 1) div i;
end;

function factorial(n: integer): biginteger;
begin
  result := 1bi;
  for var i := 2 to n do
    result *= i;
end;

function lah(n, k: integer; signed: boolean := false): biginteger;
begin
  if (n = 0) or (k = 0) or (k > n) then result := 0bi
  else
  if n = k then result := 1bi
  else
  if k = 1 then result := factorial(n)
  else
  begin
    result := binomial(n, k) * binomial(n - 1, k - 1) * factorial(n - k);
    if signed and ((n and 1) <> 0) then result := -result;
  end;
end;

begin
  for var n := 0 to 12 do
  begin
    for var k := 0 to n do
      print(lah(n, k));
    println;
  end;
  println;
  (1..100).Select(k -> lah(100, k)).Max.Println;
end.
