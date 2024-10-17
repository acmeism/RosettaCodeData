##
uses Graphwpf;

var count := 0;
while count < 100 do
begin
  var x := random(31) - 16;
  var y := random(31) - 16;
  var r := sqrt(x * x + y * y);
  if (r >= 10) and (r <= 15) then begin
    count += 1;
    fillcircle((x + 30) * 8, (y + 30) * 8, 3, colors.Black);
  end;
end;
