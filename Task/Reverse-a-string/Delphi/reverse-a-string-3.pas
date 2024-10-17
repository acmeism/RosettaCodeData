function Reverse(const s: string): string;
var
  i, aLength, ahalfLength: Integer;
  c: Char;
begin
  Result := s;
  aLength := Length(s);
  ahalfLength := aLength div 2;
  if aLength > 1 then
    for i := 1 to ahalfLength do
    begin
      c := result[i];
      result[i] := result[aLength - i + 1];
      result[aLength - i + 1] := c;
    end;
end;
