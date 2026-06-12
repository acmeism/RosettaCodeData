##
var lines := ReadAllLines('unixdict.txt');
foreach var line in lines do
  if (line.Length > 5) and (line[1:4]=line[^3:])
  then Writeln(line);
