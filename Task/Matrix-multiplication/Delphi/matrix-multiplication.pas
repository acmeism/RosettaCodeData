program Matrix_multiplication;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TMatrix = record
    values: array of array of Double;
    Rows, Cols: Integer;
    constructor Create(Rows, Cols: Integer);
    class operator Multiply(a: TMatrix; b: TMatrix): TMatrix;
    function ToString: string;
  end;

{ TMatrix }

constructor TMatrix.Create(Rows, Cols: Integer);
var
  i: Integer;
begin
  Self.Rows := Rows;
  self.Cols := Cols;
  SetLength(values, Rows);
  for i := 0 to High(values) do
    SetLength(values[i], Cols);
end;

class operator TMatrix.Multiply(a, b: TMatrix): TMatrix;
var
  rows, cols, l: Integer;
  i, j: Integer;
  sum: Double;
  k: Integer;
begin
  rows := a.Rows;
  cols := b.Cols;
  l := a.Cols;
  if l <> b.Rows then
    raise Exception.Create('Illegal matrix dimensions for multiplication');
  result := TMatrix.create(a.rows, b.Cols);
  for i := 0 to rows - 1 do
    for j := 0 to cols - 1 do
    begin
      sum := 0.0;
      for k := 0 to l - 1 do
        sum := sum + (a.values[i, k] * b.values[k, j]);
      result.values[i, j] := sum;
    end;
end;

function TMatrix.ToString: string;
var
  i, j: Integer;
begin
  Result := '[';
  for i := 0 to 2 do
  begin
    if i > 0 then
      Result := Result + #10;
    Result := Result + '[';
    for j := 0 to 2 do
    begin
      if j > 0 then
        Result := Result + ', ';
      Result := Result + format('%5.2f', [values[i, j]]);
    end;
    Result := Result + ']';
  end;
  Result := Result + ']';
end;

var
  a, b, r: TMatrix;
  i, j: Integer;

begin
  a := TMatrix.Create(3, 3);
  b := TMatrix.Create(3, 3);
  a.values := [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
  b.values := [[2, 2, 2], [5, 5, 5], [7, 7, 7]];
  r := a * b;

  Writeln('a: ');
  Writeln(a.ToString, #10);
  Writeln('b: ');
  Writeln(b.ToString, #10);
  Writeln('a * b:');
  Writeln(r.ToString);
  readln;

end.
