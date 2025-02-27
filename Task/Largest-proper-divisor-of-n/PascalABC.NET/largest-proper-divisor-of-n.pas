##
function lpd(n: integer) := range((n / 2).Ceil, 1, -1).First(x -> n mod x = 0);

for var n := 1 to 100 do
  write(lpd(n):3, if n mod 10 = 0 then #10 else '');
