program TestGnomeSort;

{$APPTYPE CONSOLE}

{.$DEFINE DYNARRAY}  // remove '.' to compile with dynamic array

type
  TItem = Integer;   // declare ordinal type for array item
{$IFDEF DYNARRAY}
  TArray = array of TItem;          // dynamic array
{$ELSE}
  TArray = array[0..15] of TItem;   // static array
{$ENDIF}

procedure GnomeSort(var A: TArray);
var
  Item: TItem;
  I, J: Integer;

begin
  I:= Low(A) + 1;
  J:= Low(A) + 2;
  while I <= High(A) do begin
    if A[I - 1] <= A[I] then begin
      I:= J;
      J:= J + 1;
    end
    else begin
      Item:= A[I - 1];
      A[I - 1]:= A[I];
      A[I]:= Item;
      I:= I - 1;
      if I = Low(A) then begin
        I:= J;
        J:= J + 1;
      end;
    end;
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
  GnomeSort(A);
  for I:= Low(A) to High(A) do
    Write(A[I]:3);
  Writeln;
  Readln;
end.
