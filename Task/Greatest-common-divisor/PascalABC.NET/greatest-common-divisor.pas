function GCD(a,b: integer): integer;
begin
  while b > 0 do
    (a,b) := (b,a mod b);
  Result := a;
end;

function GCDRec(a,b: integer): integer;
begin
  if b = 0 then
    Result := a
  else Result := GCDRec(b, a mod b);
end;

begin
  Println(GCD(72,30),GCDRec(72,30));
  Println(GCD(49865, 69811),GCDRec(49865, 69811));
end.
