function Ackermann(m,n: integer): integer;
begin
  if (m < 0) or (n < 0) then
    raise new System.ArgumentOutOfRangeException();
  if m = 0 then
    Result := n + 1
  else if n = 0 then
    Result := Ackermann(m - 1, 1)
  else Result := Ackermann(m - 1, Ackermann(m, n - 1))
end;

begin
  for var m := 0 to 3 do
  for var n := 0 to 4 do
    Println($'Ackermann({m}, {n}) = {Ackermann(m,n)}');
end.
