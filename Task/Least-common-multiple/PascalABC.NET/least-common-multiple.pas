function GCD(a,b: integer): integer;
begin
  while b > 0 do
    (a,b) := (b,a mod b);
  Result := a;
end;

function LCM(a,b: integer): integer := a = 0 ? 0 : a div GCD(a,b) * b;

begin
  Println(LCM(12,18));
end.
