Program LinearCongruentialGenerator(output);
{$mode iso}
var
  x1, x2: int64;

function bsdrand: cardinal;
  const
    a = 1103515245;
    c = 12345;
    m = 2147483648;
  begin
    x1 := (a * x1 + c) mod m;
    bsdrand := x1;
  end;

function msrand: cardinal;
  const
    a = 214013;
    c = 2531011;
    m = 2147483648;
  begin
    x2 := (a * x2 + c) mod m;
    msrand := x2 div 65536;
  end;

var
  i: cardinal;
begin
  writeln('      BSD            MS');
  x1 := 0;
  x2 := 0;
  for i := 1 to 10 do
    writeln(bsdrand:12, msrand:12);
end.
