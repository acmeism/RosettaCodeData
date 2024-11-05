##
var maxIt := 13;
var maxItJ := 10;
var a1 := 1.0;
var a2 := 0.0;
var d1 := 3.2;
println(' i       d');
for var i := 2 to maxIt do
begin
  var a := a1 + (a1 - a2) / d1;
  for var j := 1 To maxItJ do
  begin
    var x := 0.0;
    var y := 0.0;
    for var k := 1 To 1 shl i do
    begin
      y := 1.0 - 2.0 * y * x;
      x := a - x * x;
    end;
    a -= x / y;
  end;
  var d := (a1 - a2) / (a - a1);
  writeln(i:2, d:14:10);
  d1 := d;
  a2 := a1;
  a1 := a;
end;
