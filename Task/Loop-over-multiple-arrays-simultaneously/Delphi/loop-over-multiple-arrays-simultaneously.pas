program LoopOverArrays;

{$APPTYPE CONSOLE}

uses SysUtils;

const
  ARRAY1: array [1..3] of string = ('a', 'b', 'c');
  ARRAY2: array [1..3] of string = ('A', 'B', 'C');
  ARRAY3: array [1..3] of Integer = (1, 2, 3);
var
  i: Integer;
begin
  for i := 1 to 3 do
    Writeln(Format('%s%s%d', [ARRAY1[i], ARRAY2[i], ARRAY3[i]]));

  Readln;
end.
