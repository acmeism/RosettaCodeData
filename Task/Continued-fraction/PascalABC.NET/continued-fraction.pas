##
function calc(fun: integer-> (integer, integer); n: integer): decimal;
begin
  var temp := decimal(0.0);
  for var ni := n to 1 step -1 do
  begin
    var (a, b) := fun(ni);
    temp := b / (a + temp);
  end;
  result := fun(0)[0] + temp;
end;

function fsqrt2(n: integer) := (if n > 0 then 2 else 1, 1);

function fnapier(n: integer) := (if n > 0 then n else 2, if n > 1 then n - 1 else 1);

function fpi(n: integer) := (if n > 0 then 6 else 3, (2 * n - 1) * (2 * n - 1));

println(calc(fsqrt2, 200));
println(calc(fnapier, 200));
println(calc(fpi, 10000));
