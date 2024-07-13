function F(n,x,y: integer): integer;
begin
  if n = 0 then
    Result := x + y
  else if y = 0 then
    Result := x
  else Result := F(n - 1, F(n, x, y - 1), F(n, x, y - 1) + y);
end;

begin
  F(1,3,3).Println;
end.
