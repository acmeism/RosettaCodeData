##
function isCurzon(n: integer; k: biginteger) := (Power(k, n) + 1) mod (k * n + 1) = 0;

function curzonnumbers(k: integer): sequence of integer;
begin
  var n := 1;
  while true do
  begin
    if iscurzon(n, k) then yield n;
    n += 1;
  end;
end;

foreach var k in |2, 4, 6, 8, 10| do
begin
  var i := 1;
  println('Curzonnumbers with base', k);
  foreach var n in curzonnumbers(k) do
  begin
    Write(n:5);
    if (i mod 10) = 0 then println;
    if i = 50 then break;
    i += 1;
  end;
  println('1000th Curzon number', curzonnumbers(k).Skip(999).First);
  println;
end;
