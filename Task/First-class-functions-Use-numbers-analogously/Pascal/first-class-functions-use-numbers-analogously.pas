program FunTest;
{$mode objfpc}
{$modeswitch functionreferences}
{$modeswitch anonymousfunctions}
uses
  SysUtils;

type
  TMultiplier = reference to function(n: Double): Double;

function GetMultiplier(a, b: Double): TMultiplier;
var
  prod: Double;
begin
  prod := a * b;
  Result := function(n: Double): Double begin Result := prod * n end;
end;

var
  Multiplier: TMultiplier;
  I: Integer;
  x, xi, y, yi: Double;
  Numbers, Inverses:  array of Double;
begin
  x  := 2.0;
  xi := 0.5;
  y  := 4.0;
  yi := 0.25;
  Numbers := [x, y, x + y];
  Inverses := [xi, yi, 1.0 / (x + y)];
  for I := 0 to High(Numbers) do begin
    Multiplier := GetMultiplier(Numbers[I], Inverses[I]);
    WriteLn(Multiplier(0.5));
  end;
end.
