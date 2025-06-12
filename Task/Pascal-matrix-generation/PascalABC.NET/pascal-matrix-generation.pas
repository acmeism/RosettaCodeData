##
function binomial(n, k: integer): biginteger;
begin
  result := 1bi;
  for var i := 1 to k do
    result := result * (n - i + 1) div i;
end;

var m := (0..4).Select(i -> (0..4).Select(j -> binomial(i, j)));
MatrByCol(m).println;
println;
m := (0..4).Select(i -> (0..4).Select(j -> binomial(j, i)));
MatrByCol(m).println;
println;
m := (0..4).Select(i -> (0..4).Select(j -> binomial(j + i, j)));
MatrByCol(m).println;
