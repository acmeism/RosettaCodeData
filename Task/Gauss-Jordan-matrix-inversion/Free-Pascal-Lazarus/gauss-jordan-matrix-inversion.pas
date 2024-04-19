program MatrixInverse;
{$mode ObjFPC}{$H+}

const
  MATRIX_1: array of array of Real = ((1, 2, 3),
                                      (4, 1, 6),
                                      (7, 8, 9));

  MATRIX_2: array of array of Real = ((3.0, 1.0, 5.0, 9.0, 7.0),
                                      (8.0, 2.0, 8.0, 0.0, 1.0),
                                      (1.0, 7.0, 2.0, 0.0, 3.0),
                                      (0.0, 1.0, 7.0, 0.0, 9.0),
                                      (3.0, 5.0, 6.0, 1.0, 1.0));

type
  Matrix = array of array of Real;

function PopulateMatrix(A: Matrix; Order: Integer): Matrix;
var
  i, j: Integer;
begin
  SetLength(Result, Succ(Order), Succ(Order * 2));
  for i := 0 to Pred(Order) do
    for j := 0 to Pred(Order) do
      Result[i + 1, j + 1] := A[i, j];
end;

procedure PrintMatrix(const A: Matrix);
var
  i, j, Order: Integer;
begin
  Order := Length(A);
  for i := 0 to Pred(Order) do
  begin
    for j := 0 to Pred(Order) do
      Write(A[i, j]:8:4);
    WriteLn;
  end;
  WriteLn;
end;

procedure InterchangeRows(var A: Matrix; Order: Integer; Row1, Row2: Integer);
var
  j: Integer;
  temp: Real;
begin
  for j := 1 to 2 * Order do
  begin
    temp := A[Row1, j];
    A[Row1, j] := A[Row2, j];
    A[Row2, j] := temp;
  end;
end;

procedure DivideRow(var A: Matrix; Order: Integer; Row: Integer; Divisor: Real);
var
  j: Integer;
begin
  for j := 1 to 2 * Order do
    A[Row, j] := A[Row, j] / Divisor;
end;

procedure SubtractRows(var A: Matrix; Order: Integer; Row1, Row2: Integer; Multiplier: Real);
var
  j: Integer;
begin
  for j := 1 to 2 * Order do
    A[Row1, j] := A[Row1, j] - Multiplier * A[Row2, j];
end;

function GaussJordan(B: Matrix): Matrix;
var
  i, j, Order: Integer;
  Pivot, Multiplier: Real;
  A: Matrix;
begin
  Order := Length(B);
  SetLength(Result, Order, Order);
  A := PopulateMatrix(B, Order);

  // Create the augmented matrix
  for i := 1 to Order do
    for j := Order + 1 to 2 * Order do
      if j = (i + Order) then
        A[i, j] := 1;

  // Interchange rows if needed
  for i := Order downto 2 do
    if A[i - 1, 1] < A[i, 1] then
      InterchangeRows(A, Order, i - 1, i);

  // Perform Gauss-Jordan elimination
  for i := 1 to Order do
  begin
    Pivot := A[i, i];
    DivideRow(A, Order, i, Pivot);
    for j := 1 to Order do
      if j <> i then
      begin
        Multiplier := A[j, i];
        SubtractRows(A, Order, j, i, Multiplier);
      end;
  end;

  for i := 0 to Pred(Order) do
    for j := 0 to Pred(Order) do
      Result[i, j] := A[Succ(i), Succ(j) + Order];
end;

begin
  writeln('== Original Matrix ==');
  PrintMatrix(MATRIX_1);
  writeln('== Inverse Matrix ==');
  PrintMatrix(GaussJordan(MATRIX_1));

  writeln('== Original Matrix ==');
  PrintMatrix(MATRIX_2);
  writeln('== Inverse Matrix ==');
  PrintMatrix(GaussJordan(MATRIX_2));
end.
