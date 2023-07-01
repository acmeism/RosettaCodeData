Program DoMean;
uses math;
const
  vector: array [3..8] of double = (3.0, 1.0, 4.0, 1.0, 5.0, 9.0);
var
  i: integer;
  mean: double;
begin
  writeln('Calculating the arithmetic mean of a series of numbers:');
  write('Numbers: [ ');
  for i := low(vector) to high(vector) do
    write (vector[i]:3:1, ' ');
  writeln (']');
  mean := 0;
  if length(vector) > 0 then
    mean := sum(vector)/length(vector);
  writeln('Mean: ', mean:10:8);
end.
