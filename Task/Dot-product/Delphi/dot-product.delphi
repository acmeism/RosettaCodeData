program Project1;

{$APPTYPE CONSOLE}

type
  doublearray = array of Double;

function DotProduct(const A, B : doublearray): Double;
var
I: integer;
begin
  assert (Length(A) = Length(B), 'Input arrays must be the same length');
  Result := 0;
  for I := 0 to Length(A) - 1 do
    Result := Result + (A[I] * B[I]);
end;

var
  x,y: doublearray;
begin
  SetLength(x, 3);
  SetLength(y, 3);
  x[0] := 1; x[1] := 3; x[2] := -5;
  y[0] := 4; y[1] :=-2; y[2] := -1;
  WriteLn(DotProduct(x,y));
  ReadLn;
end.
