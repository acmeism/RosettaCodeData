program GElemLIst;
{$IFNDEF FPC}
  {$Apptype Console}
{$ENDIF}

uses
  math;
const
  MaxCnt = 10000;
var
  IntArr : array of integer;
  fltArr : array of double;
  i: integer;
begin
  setlength(fltArr,MaxCnt); //filled with 0
  setlength(IntArr,MaxCnt); //filled with 0.0
  randomize;
  i := random(MaxCnt);      //choose a random place
  IntArr[i] := 1;
  fltArr[i] := 1.0;
  writeln(Math.MaxIntValue(IntArr)); // Array of Integer
  writeln(Math.MaxValue(fltArr));
end.
