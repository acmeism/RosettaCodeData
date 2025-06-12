function IsPrime(N: integer): boolean;
begin
  if N = 1 then
    Result := False
  else Result := True;
  for var i:=2 to N.Sqrt.Trunc do
    if N.Divs(i) then
    begin
      Result := False;
      exit
    end;
end;

begin
  for var i:=1 to 1000 do
    if IsPrime(i) then
      Print(i)
end.
