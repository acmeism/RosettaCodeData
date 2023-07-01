program generic_test;
{$mode objfpc}{H+}
uses
  SysUtils;

generic procedure GSwap<T>(var L, R: T);
var
  Tmp: T;
begin
  Tmp := L;
  L := R;
  R := Tmp;
end;

var
  I, J: Integer;
begin
  I := 100;
  J := 11;
  WriteLn('I = ',  I, ', J = ', J);
  specialize GSwap<Integer>(I, J);
  WriteLn('I = ',  I, ', J = ', J);
end.
