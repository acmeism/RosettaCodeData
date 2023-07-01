program TestInsertionSort;

{$APPTYPE CONSOLE}

{.$DEFINE DYNARRAY}  // remove '.' to compile with dynamic array

type
  TItem = Integer;   // declare ordinal type for array item
{$IFDEF DYNARRAY}
  TArray = array of TItem;          // dynamic array
{$ELSE}
  TArray = array[0..15] of TItem;   // static array
{$ENDIF}

procedure InsertionSort(var A: TArray);
var
  I, J: Integer;
  Item: TItem;

begin
  for I:= 1 + Low(A) to High(A) do begin
    Item:= A[I];
    J:= I - 1;
    while (J >= Low(A)) and (A[J] > Item) do begin
      A[J + 1]:= A[J];
      Dec(J);
    end;
    A[J + 1]:= Item;
  end;
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
  InsertionSort(A);
  for I:= Low(A) to High(A) do
    Write(A[I]:3);
  Writeln;
  Readln;
end.
