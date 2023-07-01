program QSortDemo;

{$mode objfpc}{$h+}{$b-}

procedure QuickSort(var A: array of Integer);
  procedure QSort(L, R: Integer);
  var
    I, J, Tmp, Pivot: Integer;
  begin
    if R - L < 1 then exit;
    I := L; J := R;
    {$push}{$q-}{$r-}Pivot := A[(L + R) shr 1];{$pop}
    repeat
      while A[I] < Pivot do Inc(I);
      while A[J] > Pivot do Dec(J);
      if I <= J then begin
        Tmp := A[I];
        A[I] := A[J];
        A[J] := Tmp;
        Inc(I); Dec(J);
      end;
    until I > J;
    QSort(L, J);
    QSort(I, R);
  end;
begin
  QSort(0, High(A));
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
  QuickSort(a);
  PrintArray(a);
end.
