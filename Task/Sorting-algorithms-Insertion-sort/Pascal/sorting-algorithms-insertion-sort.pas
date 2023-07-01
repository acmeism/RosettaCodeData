program SortDemo;

{$mode objfpc}{$h+}{$b-}

procedure InsertionSort(var A: array of Integer);
var
  I, J, Tmp: Integer;
begin
  for I := 1 to High(a) do
    if A[I] < A[I - 1] then begin
      J := I;
      Tmp := A[I];
      repeat
        A[J] := A[J - 1];
        Dec(J);
      until (J = 0) or (Tmp >= A[J - 1]);
      A[J] := Tmp;
    end;
end;

procedure PrintArray(const A: array of Integer);
var
  I: Integer;
begin
  Write('[');
  for I := 0 to High(A) - 1 do
    Write(A[I], ', ');
  WriteLn(A[High(A)], ']');
end;

var
  a: array[-7..6] of Integer = (-34, -20, 30, 13, 36, -10, 5, -25, 9, 19, 35, -50, 29, 11);

begin
  InsertionSort(a);
  PrintArray(a);
end.
