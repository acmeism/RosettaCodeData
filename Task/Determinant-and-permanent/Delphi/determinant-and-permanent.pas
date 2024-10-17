program Determinant_and_permanent;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TMatrix = TArray<TArray<Double>>;

function Minor(a: TMatrix; x, y: Integer): TMatrix;
begin
  var len := Length(a) - 1;
  SetLength(result, len, len);
  for var i := 0 to len - 1 do
  begin
    for var j := 0 to len - 1 do
    begin
      if ((i < x) and (j < y)) then
      begin
        result[i][j] := a[i][j];
      end
      else if ((i >= x) and (j < y)) then
      begin
        result[i][j] := a[i + 1][j];
      end
      else if ((i < x) and (j >= y)) then
      begin
        result[i][j] := a[i][j + 1];
      end
      else //i>x  and  j>y
        result[i][j] := a[i + 1][j + 1];
    end;
  end;
end;

function det(a: TMatrix): Double;
begin
  if length(a) = 1 then
    exit(a[0][0]);

  var sign := 1;
  result := 0.0;
  for var i := 0 to high(a) do
  begin
    result := result + sign * a[0][i] * det(minor(a, 0, i));
    sign := sign *  - 1;
  end;
end;

function perm(a: TMatrix): Double;
begin
  if Length(a) = 1 then
    exit(a[0][0]);
  Result := 0;
  for var i := 0 to high(a) do
    result := result + a[0][i] * perm(Minor(a, 0, i));
end;

function Readint(Min, Max: Integer; Prompt: string): Integer;
var
  val: string;
  vali: Integer;
begin
  Result := -1;
  repeat
    writeln(Prompt);
    Readln(val);
    if TryStrToInt(val, vali) then
      if (vali < Min) or (vali > Max) then
        writeln(vali, ' is out range [', Min, '...', Max, ']')
      else
        exit(vali)
    else
      writeln(val, ' is not a number valid');
  until false;
end;

function ReadDouble(Min, Max: double; Prompt: string): double;
var
  val: string;
  vali: double;
begin
  Result := -1;
  repeat
    writeln(Prompt);
    Readln(val);
    if TryStrToFloat(val, vali) then
      if (vali < Min) or (vali > Max) then
        writeln(vali, ' is out range [', Min, '...', Max, ']')
      else
        exit(vali)
    else
      writeln(val, ' is not a number valid');
  until false;
end;

procedure ShowMatrix(a: TMatrix);
begin
  var sz := length(a);
  for var i := 0 to sz - 1 do
  begin
    Write('[');
    for var j := 0 to sz - 1 do
      write(a[i][j]: 3: 2, ' ');
    Writeln(']');
  end;
end;

var
  a: TMatrix;
  sz: integer;

begin
  sz := Readint(1, 10, 'Enter with matrix size: ');
  SetLength(a, sz, sz);
  for var i := 0 to sz - 1 do
    for var j := 0 to sz - 1 do
    begin
      a[i][j] := ReadDouble(-1000, 1000, format('Enter a value of position (%d,%d):',
        [i, j]));
    end;

  writeln('Matrix defined: ');
  ShowMatrix(a);
  writeln(#10'Determinant: ', det(a): 3: 2);
  writeln(#10'Permanent: ', perm(a): 3: 2);
  readln;
end.
