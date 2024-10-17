function IsCusip(s: string): boolean;
begin
  result := false;
  if (s.Length <> 9) then exit;
  var sum := 0;
  var v := 0;
  for var i := 1 to 8 do
  begin
    var c := s[i];
    if c.isdigit then
      v := c.todigit
    else if (c >= 'A') and (c <= 'Z') then
      v := ord(c) - ord('A') + 10
    else if c = '*' then
      v := 36
    else if c = '@' then
      v := 37
    else if c = '#' then
      v := 38;
    if (i mod 2) = 0 then
      v := v * 2;
    sum += (v div 10) + (v mod 10);
  end;
  var check := (10 - (sum mod 10)) mod 10;
  result := s[9].todigit = check;
end;

begin
  var candidates := |'037833100', '17275R102', '38259P508', '594918104', '68389X106', '68389X105'|;
  foreach var candidate in candidates do
    println(candidate, if IsCusip(candidate) then 'correct' else 'incorrect');
end.
