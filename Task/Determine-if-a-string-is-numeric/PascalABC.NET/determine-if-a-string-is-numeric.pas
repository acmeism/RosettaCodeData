function IsNumeric(s: string): boolean;
begin
  var i: integer;
  Result := integer.TryParse(s,i)
end;

begin
  var s := '123';
  if IsNumeric(s) then
    Print('string is numeric')
end.
