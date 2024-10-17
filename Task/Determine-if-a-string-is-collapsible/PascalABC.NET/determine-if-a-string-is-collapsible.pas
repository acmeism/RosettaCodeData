##
function Collapse(s: String) :=
  if String.IsNullOrEmpty(s) Then ''
  else s[1] +
       new String(Range(2, s.Length)
       .Where(i -> s[i] <> s[i - 1])
       .Select(i -> s[i])
       .ToArray);

var input :=
|'',
'The better the 4-wheel drive, the further you''ll be from help when ya get stuck!',
'headmistressship',
'"If I were two-faced, would I be wearing this one? --- Abraham Lincoln "',
'..1111111111111111111111111111111111111111111111111111111111111117777888',
'I never give ''em hell, I just tell the truth, and they think it''s hell. ',
'                                                    --- Harry S Truman  '|;

foreach var s in input do
begin
  Writeln('old: ', s.Length, ' «««', s, '»»»');
  var c := Collapse(s);
  WriteLn('new: ', c.Length, ' «««', c, '»»»')
end;
