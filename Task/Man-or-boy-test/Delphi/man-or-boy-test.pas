type
  TFunc<T> = reference to function: T;

function C(x: Integer): TFunc<Integer>;
begin
  Result := function: Integer
  begin
    Result := x;
  end;
end;

function A(k: Integer; x1, x2, x3, x4, x5: TFunc<Integer>): Integer;
var
  b: TFunc<Integer>;
begin
  b := function: Integer
  begin
    Dec(k);
    Result := A(k, b, x1, x2, x3, x4);
  end;
  if k <= 0 then
    Result := x4 + x5
  else
    Result := b;
end;

begin
  Writeln(A(10, C(1), C(-1), C(-1), C(1), C(0))); // -67 output
end.
