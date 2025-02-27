##
function humbles: sequence of uint64;
begin
  var s := hset(uint64(1));
  while True do
  begin
    var m := s.min;
    yield m;
    s -= m;
    foreach var k in |2, 3, 5, 7| do s += k * m;
  end;
end;

println('The first 50 humble numbers are:');
foreach var n in humbles.Take(50) index i do
  write(n:4, if i mod 10 = 9 then #10 else '');

println;
println('Digits Count');
for var dig := 1 to 18 do
begin
  var count := humbles.SkipWhile(x -> x < 10 ** (dig - 1))
                      .TakeWhile(x -> x < 10 ** dig).Count;
  writeln(dig:2, count:10);
end;
