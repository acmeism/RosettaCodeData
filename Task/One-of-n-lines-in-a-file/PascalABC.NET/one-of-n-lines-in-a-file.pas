##
function oneOfN(n: integer): integer;
begin
  result := 0;
  for var x := 0 to n-1  do
    if random(x+1) = 0 then
      result := x;
end;

function oneOfNTest(n: integer := 10; trials: integer := 1_000_000): array of integer;
begin
  result := new integer[n];
  if n >= 0 then
    foreach var i in 1..trials do
      result[oneOfN(n)] += 1;
end;

oneOfNTest.println;
