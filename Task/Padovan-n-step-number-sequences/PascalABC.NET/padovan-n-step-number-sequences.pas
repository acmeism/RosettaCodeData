##
function rn(n, k: integer): list<integer>;
begin
  assert(k >= 2);
  result := if n = 2 then Lst(1, 1, 1) else rn(n - 1, n + 1);
  while result.Count <> k do
    result.Add(result[^(n + 1):^1].Sum);
end;

for var n := 2 to 8 do
  println(n, ': ', rn(n, 15));
