##
function mfac(n, m: integer) := range(n, 1, -m).aggregate(1, (p, x) -> p * x);

function mfac2(n, m: integer): integer := if n <= (m + 1) then n else n * mfac2(n - m, m);

foreach var m in (1..5) do
begin
  write(#10, m, ': ');
  foreach var n in (1..10) do
    mfac2(n, m).Print;
end;
