program Roots_of_unity;

{$APPTYPE CONSOLE}

uses
  System.VarCmplx;

function RootOfUnity(degree: integer): Tarray<Variant>;
var
  k: Integer;
begin
  SetLength(result, degree);
  for k := 0 to degree - 1 do
    Result[k] := VarComplexFromPolar(1, 2 * pi * k / degree);
end;

const
  n = 3;
var
  num: Variant;
begin
  Writeln('Root of unity from ', n, ':'#10);
  for num in RootOfUnity(n) do
    Writeln(num);
  Readln;
end.
