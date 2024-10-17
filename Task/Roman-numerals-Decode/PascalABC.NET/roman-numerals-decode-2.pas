function romanDecode(roman: String): Integer;
begin
  result := 0;
  if roman = '' then exit;
  var n := 0;
  var last := 'O';
  foreach var c in roman do
  begin
    case c of
      'I': n += 1;
      'V': if (last = 'I') then n += 3   else n += 5;
      'X': if (last = 'I') then n += 8   else n += 10;
      'L': if (last = 'X') then n += 30  else n += 50;
      'C': if (last = 'X') then n += 80  else n += 100;
      'D': if (last = 'C') then n += 300 else n += 500;
      'M': if (last = 'C') then n += 800 else n += 1000;
    end;
    last := c;
  end;
  result := n;
end;

begin
  var romans := |'I', 'III', 'IV', 'VIII', 'XLIX', 'CCII',
                 'CDXXXIII', 'MCMXC', 'MMVIII', 'MDCLXVI'|;
  foreach var roman in romans do
    writeln(roman:10, romanDecode(roman):10);
end.
