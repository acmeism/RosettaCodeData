##
function isforbidden(num: integer): boolean;
begin
  //true if num is a forbidden number
  var fours := num;
  var pow4 := 0;
  while (fours > 1) and (fours mod 4 = 0) do
  begin
    fours := fours div 4;
    pow4 += 1;
  end;
  result := (num div int64(4 ** pow4)) mod 8 = 7;
end;

var f500k := (0..500_001).Where(n -> isforbidden(n));

f500k.Take(50).println;
println;
foreach var fbmax in |500, 5000, 50_000, 500_000| do
  println('There are', f500k.Where(x -> x <= fbmax).Count, 'forbidden numbers <=', fbmax)
