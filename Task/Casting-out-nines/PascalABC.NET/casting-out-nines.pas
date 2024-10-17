##
function co9(x: integer): integer;
begin
  if x = 9 then result := 0
  else if x < 9 then result := x
  else result := co9(x.ToString.select(x -> StrToInt(x)).sum);
end;

var kaprekars := [1, 9, 45, 55, 99, 297, 703, 999];

Print('Checksums: '); (1..20).Select(x -> co9(x)).Println;
Print('co9(k) = co9(k*k): ');
Println((1..1000).Where(x -> co9(x) = co9(x * x)));
var part2 := (1..1000).Where(x -> co9(x) = co9(x * x)).ToSet;
Println('Kaprekars: ', kaprekars);
if kaprekars <= part2 then Println('Kaprekars are included.', part2.Count, 'numbers in range 1000');
