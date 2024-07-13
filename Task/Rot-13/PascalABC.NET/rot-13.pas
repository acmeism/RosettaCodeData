function Rot13(s: string): string;
begin
  var sb := new StringBuilder;
  foreach var c in s do
  begin
    var c1 := c;
    if c in 'a'..'z' then
      c1 := Chr((c.Code - 'a'.Code + 13) mod 26 + 'a'.Code)
    else if c in 'A'..'Z' then
      c1 := Chr((c.Code - 'A'.Code + 13) mod 26 + 'A'.Code);
    sb.Append(c1)
  end;
  Result := sb.ToString;
end;

begin
  Println(rot13('foo'));
  Println(rot13('sbb'))
end.
