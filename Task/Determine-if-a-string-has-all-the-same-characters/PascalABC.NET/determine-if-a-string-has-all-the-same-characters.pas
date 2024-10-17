procedure Analyze(s: String);
begin
  writeln('Examining ''', s, ''' which has a length of ', s.Length);
  if s.Length > 1 Then
    foreach var c in s index i do
      if c <> s[1] Then
      begin
        WriteLn('    Not all characters in the string are the same.');
        WriteLn('    ''', c, ''' (0x', ord(c).tostring('x'), ')', ' is different at position ', i + 1);
        exit;
      end;
  WriteLn('    All characters in the string are the same.')
end;

begin
  var strs := |'', '    ', '2', '333', '.55', 'tttTTT', '4444 444k'|;
  foreach var s In strs do
    Analyze(s);
end.
