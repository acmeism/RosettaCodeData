##
var fact := |1| * 12;
for var i := 1 to 11 do fact[i] := i * fact[i - 1];

for var b := 9 to 12 do
begin
  write('The factorions for base ', b:2, ' are: ');
  for var i := 1 to 1_500_000 do
  begin
    var fact_sum := 0;
    var j := i;
    while j > 0 do
    begin
      var d := j mod b;
      fact_sum += fact[d];
      j := j div b;
    end;
    if fact_sum = i then
      print(i)
  end;
  println;
end;
