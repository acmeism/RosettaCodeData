program CholeskyApp;

type
  D2Array = array of array of double;

function cholesky(const A: D2Array): D2Array;
var
  i, j, k: integer;
  s: double;
begin
  setlength(Result, length(A), length(A));
  for i := low(Result) to high(Result) do
    for j := 0 to i do
    begin
      s := 0;
      for k := 0 to j - 1 do
        s := s + Result[i][k] * Result[j][k];
      if i = j then
        Result[i][j] := sqrt(A[i][i] - s)
      else
        Result[i][j] := (A[i][j] - s) / Result[j][j];  // save one multiplication compared to the original
    end;
end;

procedure printM(const A: D2Array);
var
  i, j: integer;
begin
  for i := low(A) to high(A) do
  begin
    for j := low(A) to high(A) do
      write(A[i, j]: 8: 5);
    writeln;
  end;
end;

const
  m1: array[0..2, 0..2] of double = ((25, 15, -5), (15, 18, 0), (-5, 0, 11));
  m2: array[0..3, 0..3] of double = ((18, 22, 54, 42), (22, 70, 86, 62), (54, 86,
    174, 134), (42, 62, 134, 106));

var
  index, i: integer;
  cIn, cOut: D2Array;

begin
  setlength(cIn, length(m1), length(m1));
  for index := low(m1) to high(m1) do
  begin
    SetLength(cIn[index], length(m1[index]));
    for i := 0 to High(m1[Index]) do
      cIn[index][i] := m1[index][i];
  end;
  cOut := cholesky(cIn);
  printM(cOut);

  writeln;

  setlength(cIn, length(m2), length(m2));
  for index := low(m2) to high(m2) do
  begin
    SetLength(cIn[index], length(m2[Index]));
    for i := 0 to High(m2[Index]) do
      cIn[index][i] := m2[index][i];
  end;
  cOut := cholesky(cIn);
  printM(cOut);
end.
