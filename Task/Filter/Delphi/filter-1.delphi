program FilterEven;

{$APPTYPE CONSOLE}

uses SysUtils, Types;

const
  SOURCE_ARRAY: array[0..9] of Integer = (0,1,2,3,4,5,6,7,8,9);
var
  i: Integer;
  lEvenArray: TIntegerDynArray;
begin
  for i in SOURCE_ARRAY do
  begin
    if not Odd(i) then
    begin
      SetLength(lEvenArray, Length(lEvenArray) + 1);
      lEvenArray[Length(lEvenArray) - 1] := i;
    end;
  end;

  for i in lEvenArray do
    Write(i:3);
  Writeln;
end.
