uses System.IO;

begin
  var lines := File.ReadAllLines('unixdict.txt');

  foreach var line in lines do
  begin
    if (line.Length > 11) and line.Contains('the') then
      Writeln(line);
  end;
end.
