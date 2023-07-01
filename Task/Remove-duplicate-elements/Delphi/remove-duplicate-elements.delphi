program RemoveDuplicateElements;

{$APPTYPE CONSOLE}

uses Generics.Collections;

var
  i: Integer;
  lIntegerList: TList<Integer>;
const
  INT_ARRAY: array[1..7] of Integer = (1, 2, 2, 3, 4, 5, 5);
begin
  lIntegerList := TList<Integer>.Create;
  try
  for i in INT_ARRAY do
    if not lIntegerList.Contains(i) then
      lIntegerList.Add(i);

  for i in lIntegerList do
    Writeln(i);
  finally
    lIntegerList.Free;
  end;
end.
