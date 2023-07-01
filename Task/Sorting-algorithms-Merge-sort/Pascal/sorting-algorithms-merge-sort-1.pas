program MergeSortDemo;

{$mode objfpc}{$h+}

procedure MergeSort(var A: array of Integer);
var
  Buf: array of Integer;
  procedure Merge(L, M, R: Integer);
  var
    I, J, K: Integer;
  begin
    I := L;
    J := Succ(M);
    for K := 0 to R - L do
      if (J > R) or (I <= M) and (A[I] <= A[J]) then begin
        Buf[K] := A[I];
        Inc(I);
      end else begin
        Buf[K] := A[J];
        Inc(J);
      end;
    Move(Buf[0], A[L], Succ(R - L) * SizeOf(Integer));
  end;
  procedure MSort(L, R: Integer);
  var
    M: Integer;
  begin
    if R > L then begin
      {$push}{$q-}{$r-}M := (L + R) shr 1;{$pop}
      MSort(L, M);
      MSort(M + 1, R);
      if A[M] > A[M + 1] then
        Merge(L, M, R);
    end;
  end;
begin
  if Length(A) > 1 then begin
    SetLength(Buf, Length(A));
    MSort(0, High(A));
  end;
end;

procedure PrintArray(const Name: string; const A: array of Integer);
var
  I: Integer;
begin
  Write(Name, ': [');
  for I := 0 to High(A) - 1 do
    Write(A[I], ', ');
  WriteLn(A[High(A)], ']');
end;

var
  a1: array[-7..5] of Integer = (27, -47, 14, 39, 47, -2, -8, 20, 18, 22, -49, -40, -8);
  a2: array of Integer = (9, -25, -16, 24, 39, 42, 20, 20, 39, 10, -47, 28);
begin
  MergeSort(a1);
  PrintArray('a1', a1);
  MergeSort(a2);
  PrintArray('a2', a2);
end.
