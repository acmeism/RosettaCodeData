program Randoms;

{$APPTYPE CONSOLE}

uses
  Math;

var
  Values: array[0..999] of Double;
  I: Integer;

begin
//  Randomize;   Commented to obtain reproducible results
  for I:= Low(Values) to High(Values) do
    Values[I]:= RandG(1.0, 0.5);  // Mean = 1.0, StdDev = 0.5
  Writeln('Mean          = ', Mean(Values):6:4);
  Writeln('Std Deviation = ', StdDev(Values):6:4);
  Readln;
end.
