##
function binom(n, k: integer): int64;
begin
  result := 1;
  for var i := 1 to k do
    result := result * (n - i + 1) div i
end;

function catalan1(n: integer) := binom(2 * n, n) div (n + 1);

function catalan2(n: integer): integer;
begin
  if n = 0 then begin result := 1; exit end;
  for var i := 0 to n - 1 do
    result += catalan2(i) * catalan2(n - 1 - i)
end;

function catalan3(n: integer): integer;
begin
  if n > 0 then result := 2 * (2 * n - 1) * catalan3(n - 1) div (1 + n)
  else result := 1;
end;

for var i := 0 to 15 do
  writeln(i:2, catalan1(i):9, catalan2(i):9, catalan3(i):9);
