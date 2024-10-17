program TestShakerSort;

{$APPTYPE CONSOLE}

{.$DEFINE DYNARRAY}  // remove '.' to compile with dynamic array

type
  TItem = Integer;   // declare ordinal type for array item
{$IFDEF DYNARRAY}
  TArray = array of TItem;          // dynamic array
{$ELSE}
  TArray = array[0..15] of TItem;   // static array
{$ENDIF}

procedure ShakerSort(var A: TArray);
var
  Item: TItem;
  K, L, R, J: Integer;

begin
  L:= Low(A) + 1;
  R:= High(A);
  K:= High(A);
  repeat
    for J:= R downto L do begin
      if A[J - 1] > A[J] then begin
        Item:= A[J - 1];
        A[J - 1]:= A[J];
        A[J]:= Item;
        K:= J;
      end;
    end;
    L:= K + 1;
    for J:= L to R do begin
      if A[J - 1] > A[J] then begin
        Item:= A[J - 1];
        A[J - 1]:= A[J];
        A[J]:= Item;
        K:= J;
      end;
    end;
    R:= K - 1;
  until L > R;
end;

var
  A: TArray;
  I: Integer;

begin
{$IFDEF DYNARRAY}
  SetLength(A, 16);
{$ENDIF}
  for I:= Low(A) to High(A) do
    A[I]:= Random(100);
  for I:= Low(A) to High(A) do
    Write(A[I]:3);
  Writeln;
  ShakerSort(A);
  for I:= Low(A) to High(A) do
    Write(A[I]:3);
  Writeln;
  Readln;
end.
