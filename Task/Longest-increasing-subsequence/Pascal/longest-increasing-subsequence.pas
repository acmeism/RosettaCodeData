program LisDemo;
{$mode objfpc}{$h+}
uses
  SysUtils;

function Lis(const A: array of Integer): specialize TArray<Integer>;
var
  TailIndex: array of Integer;
  function CeilIndex(Value, R: Integer): Integer;
  var
    L, M: Integer;
  begin
    L := 0;
    while L < R do begin
      {$PUSH}{$Q-}{$R-}M := (L + R) shr 1;{$POP}
      if A[TailIndex[M]] < Value then L := M + 1
      else R := M;
    end;
    Result := R;
  end;
var
  I, J, Len: Integer;
  Parents: array of Integer;
begin
  Result := nil;
  if Length(A) = 0 then exit;
  SetLength(TailIndex, Length(A));
  SetLength(Parents, Length(A));
  Len := 1;
  for I := 1 to High(A) do
    if A[I] < A[TailIndex[0]] then
      TailIndex[0] := I
    else
      if A[TailIndex[Len-1]] < A[I] then begin
        Parents[I] := TailIndex[Len - 1];
        TailIndex[Len] := I;
        Inc(Len);
      end else begin
        J := CeilIndex(A[I], Len - 1);
        Parents[I] := TailIndex[J - 1];
        TailIndex[J] := I;
      end;
  if Len < 2 then exit([A[0]]);
  SetLength(Result, Len);
  J := TailIndex[Len - 1];
  for I := Len - 1 downto 0 do begin
    Result[I] := A[J];
    J := Parents[J];
  end;
end;

procedure PrintArray(const A: array of Integer);
var
  I: SizeInt;
begin
  Write('[');
  for I := 0 to High(A) - 1 do
    Write(A[I], ', ');
  WriteLn(A[High(A)], ']');
end;

begin
  PrintArray(Lis([3, 2, 6, 4, 5, 1]));
  PrintArray(Lis([0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]));
  PrintArray(Lis([1, 1, 1, 1, 1, 0]));
end.
