program TestBubbleSort;

{$APPTYPE CONSOLE}

{.$DEFINE DYNARRAY}  // remove '.' to compile with dynamic array

type
  TItem = Integer;   // declare ordinal type for array item
{$IFDEF DYNARRAY}
  TArray = array of TItem;          // dynamic array
{$ELSE}
  TArray = array[0..15] of TItem;   // static array
{$ENDIF}

procedure BubbleSort(var A: TArray);
var
  Item: TItem;
  K, L, J: Integer;

begin
  L:= Low(A) + 1;
  repeat
    K:= High(A);
    for J:= High(A) downto L do begin
      if A[J - 1] > A[J] then begin
        Item:= A[J - 1];
        A[J - 1]:= A[J];
        A[J]:= Item;
        K:= J;
      end;
    end;
    L:= K + 1;
  until L > High(A);
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
  BubbleSort(A);
  for I:= Low(A) to High(A) do
    Write(A[I]:3);
  Writeln;
  Readln;
end.
