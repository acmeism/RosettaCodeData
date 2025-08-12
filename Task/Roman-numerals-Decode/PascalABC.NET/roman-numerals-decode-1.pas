function romanDecode(roman: string): integer;
begin
  var values := Dict('I' to 1, 'V' to 5, 'X' to 10, 'L' to 50, 'C' to 100, 'D' to 500, 'M' to 1000);
  Result := 0;
  var prev := 0;
  for var i := roman.Length downto 1 do
  begin
    var curr := values[roman[i]];
    if curr < prev
    then Result -= curr
    else Result += curr;
    prev := curr;
  end;
end;
begin
  var romans := |'I', 'III', 'IV', 'VIII', 'XLIX', 'CCII',
                 'CDXXXIII', 'MCMXC', 'MMVIII', 'MDCLXVI'|;
  foreach var roman in romans do
    writeln(roman:8, romanDecode(roman):7);
end.
