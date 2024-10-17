program Matrix_exponentiation_operator;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TCells = array of array of double;

  TMatrix = record
  private
    FCells: TCells;
    function GetCells(r, c: Integer): Double;
    procedure SetCells(r, c: Integer; const Value: Double);
    class operator Implicit(a: TMatrix): string;
    class operator BitwiseXor(a: TMatrix; e: Integer): TMatrix;
    class operator Multiply(a: TMatrix; b: TMatrix): TMatrix;
  public
    constructor Create(w, h: integer); overload;
    constructor Create(c: TCells); overload;
    constructor Ident(size: Integer);
    function Rows: Integer;
    function Columns: Integer;
    property Cells[r, c: Integer]: Double read GetCells write SetCells; default;
  end;

{ TMatrix }

constructor TMatrix.Create(c: TCells);
begin
  Create(Length(c), Length(c[0]));
  FCells := c;
end;

constructor TMatrix.Create(w, h: integer);
begin
  SetLength(FCells, w, h);
end;

class operator TMatrix.BitwiseXor(a: TMatrix; e: Integer): TMatrix;
begin
  if e < 0 then
    raise Exception.Create('Matrix inversion not implemented');

  Result.Ident(a.Rows);
  while e > 0 do
  begin
    Result := Result * a;
    dec(e);
  end;
end;

function TMatrix.Rows: Integer;
begin
  Result := Length(FCells);
end;

function TMatrix.Columns: Integer;
begin
  Result := 0;
  if Rows > 0 then
    Result := Length(FCells);
end;

function TMatrix.GetCells(r, c: Integer): Double;
begin
  Result := FCells[r, c];
end;

constructor TMatrix.Ident(size: Integer);
var
  i: Integer;
begin
  Create(size, size);

  for i := 0 to size - 1 do
    Cells[i, i] := 1;
end;

class operator TMatrix.Implicit(a: TMatrix): string;
var
  i, j: Integer;
begin
  Result := '[';
  if a.Rows > 0 then
    for i := 0 to a.Rows - 1 do
    begin
      if i > 0 then
        Result := Trim(Result) + ']'#10'[';
      for j := 0 to a.Columns - 1 do
      begin
        Result := Result + Format('%f', [a[i, j]]) + ' ';
      end;
    end;
  Result := trim(Result) + ']';
end;

class operator TMatrix.Multiply(a, b: TMatrix): TMatrix;
var
  size: Integer;
  r: Integer;
  c: Integer;
  k: Integer;
begin
  if (a.Rows <> b.Rows) or (a.Columns <> b.Columns) then
    raise Exception.Create('The matrix must have same size');

  size := a.Rows;
  Result.Create(size, size);

  for r := 0 to size - 1 do
    for c := 0 to size - 1 do
    begin
      Result[r, c] := 0;
      for k := 0 to size - 1 do
        Result[r, c] := Result[r, c] + a[r, k] * b[k, c];
    end;
end;

procedure TMatrix.SetCells(r, c: Integer; const Value: Double);
begin
  FCells[r, c] := Value;
end;

var
  M: TMatrix;

begin
  M.Create([[3, 2], [2, 1]]);
// Delphi don't have a ** and can't override ^ operator, then XOR operator was used
  Writeln(string(M xor 0), #10);
  Writeln(string(M xor 1), #10);
  Writeln(string(M xor 2), #10);
  Writeln(string(M xor 3), #10);
  Writeln(string(M xor 4), #10);
  Writeln(string(M xor 50), #10);
  Readln;
end.
