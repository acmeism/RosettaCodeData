Program Mean;

  function DoMean(vector: array of double): double;
  var
    sum: double;
    i, len: integer;
  begin
    sum := 0;
    len := length(vector);
    if len > 0 then
      begin
      for i := low(vector) to high(vector) do
	sum := sum + vector[i];
      sum := sum / len;
      end;
     DoMean := sum;
  end;

const
  vector: array [3..8] of double = (3.0, 1.0, 4.0, 1.0, 5.0, 9.0);
var
  i: integer;
begin
  writeln('Calculating the arithmetic mean of a series of numbers:');
  write('Numbers: [ ');
  for i := low(vector) to high(vector) do
    write (vector[i]:3:1, ' ');
  writeln (']');
  writeln('Mean: ', DoMean(vector):10:8);
end.
