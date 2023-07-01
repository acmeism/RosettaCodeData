program geometric_mean;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function Fabs(value: Double): Double;
begin
  Result := value;
  if Result < 0 then
    Result := -Result;
end;

function agm(a, g: Double):Double;
var
  iota, a1, g1: Double;
begin
  iota := 1.0E-16;
  if a * g < 0.0 then
  begin
    Writeln('arithmetic-geometric mean undefined when x*y<0');
    exit(1);
  end;

  while Fabs(a - g) > iota do
  begin
    a1 := (a + g) / 2.0;
    g1 := sqrt(a * g);
    a := a1;
    g := g1;
  end;
  Exit(a);
end;

var
  x, y: Double;

begin
  Write('Enter two numbers:');
  Readln(x, y);
  writeln(format('The arithmetic-geometric mean is  %.6f', [agm(x, y)]));
  readln;
end.
