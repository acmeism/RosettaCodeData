{$zerobasedstrings}
function NestedToIndented(nested: string): string;
begin
  var lst := new List<string>;
  foreach var line in Regex.Split(nested,NewLine) do
  begin
    var ind := Regex.Match(line,'[^\.]').Index;
    lst.Add($'{ind div 4} {line[ind:]}');
  end;
  Result := lst.JoinToString(NewLine);
end;

function IndentedToNested(indented: string): string;
begin
  var lst := new List<string>;
  foreach var line in Regex.Split(indented,NewLine) do
  begin
    var ind := line.IndexOf(' ');
    var level := line[:ind].ToInteger;
    lst.Add((level*4) * '.' + line[ind+1:]);
  end;
  Result := lst.JoinToString(NewLine);
end;

begin
  var initialNested := '''
    Rosetta Code
    ....rocks
    ........code
    ........comparison
    ........wiki
    ....mocks
    ........trolling
    ''';
	Writeln(initialNested,NewLine);
	var indented := NestedToIndented(initialNested);
	Writeln(indented,NewLine);
	var nested := IndentedToNested(indented);
	Writeln(nested,NewLine);
	Writeln($'Initial = Restored: {initialNested = nested}');
end.
