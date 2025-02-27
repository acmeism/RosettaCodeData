program reduceApp;

{$modeswitch classicProcVars+}

{Works in many modes with Free Pascal Compiler:
fpc, objfpc, delphi, macpas, iso, extendedpascal}

type
   Num = LongInt;  // this can be changed to Real if desired
   BinaryFunc = function(a, b: Num): Num;

function add(x, y: Num): Num; begin add := x + y; end;
function sub(x, y: Num): Num; begin sub := x - y; end;
function mul(x, y: Num): Num; begin mul := x * y; end;

function reduce(func: BinaryFunc; a: array of Num): Num;
var
   i: Integer;
   answer: Num;
begin
   answer := a[low(a)];
   for i := low(a)+1 to high(a) do
      answer := func(answer, a[i]);
   reduce := answer;  // return answer
end;

VAR
   // dynamic array
   ma: array of Num;
   // static arrays
   mb: array[1..9] of Num = (1,2,3,4,5,6,7,8,9);
   mc: array[0..8] of Num = (1,2,3,4,5,6,7,8,9);
BEGIN
   ma := [1,2,3,4,5,6,7,8,9];
   writeln(reduce(add, ma));
   writeln(reduce(sub, mb));
   writeln(reduce(mul, mc));
END.
