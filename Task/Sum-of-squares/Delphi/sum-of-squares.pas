program SumOfSq;

{$APPTYPE CONSOLE}

uses Math;

type
  TDblArray = array of Double;

var
  A: TDblArray;

begin
  Writeln(SumOfSquares([]):6:2);            //  0.00
  Writeln(SumOfSquares([1, 2, 3, 4]):6:2);  // 30.00
  A:= nil;
  Writeln(SumOfSquares(A):6:2);             //  0.00
  A:= TDblArray.Create(1, 2, 3, 4);
  Writeln(SumOfSquares(A):6:2);             // 30.00
  Readln;
end.
