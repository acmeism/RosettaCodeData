##
function binomial(n, k: integer): biginteger;
begin
  result := 1bi;
  for var i := 1 to k do
    result *= (n - i + 1) div i;
end;

Println(binomial(5, 3))
