program SumAndProductOfArray;

{$APPTYPE CONSOLE}

var
  i: integer;
  lIntArray: array [1 .. 5] of integer = (1, 2, 3, 4, 5);
  lSum: integer = 0;
  lProduct: integer = 1;
begin
  for i := 1 to length(lIntArray) do
  begin
    Inc(lSum, lIntArray[i]);
    lProduct := lProduct * lIntArray[i]
  end;

  Write('Sum: ');
  Writeln(lSum);
  Write('Product: ');
  Writeln(lProduct);
end.
