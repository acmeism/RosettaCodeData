Program SumSeries;
type
  tOutput = double;//extended;
  tmyFunc = function(number: LongInt): tOutput;

function f(number: LongInt): tOutput;
begin
  f := 1/sqr(tOutput(number));
end;

function Sum(from,upto: LongInt;func:tmyFunc):tOutput;
var
  res: tOutput;
begin
  res := 0.0;
//  for from:= from to upto do res := res + f(from);
  for upTo := upto downto from do res := res + f(upTo);
  Sum := res;
end;

BEGIN
  writeln('The sum of 1/x^2 from 1 to 1000 is: ', Sum(1,1000,@f));
  writeln('Whereas pi^2/6 is:                  ', pi*pi/6:10:8);
end.
