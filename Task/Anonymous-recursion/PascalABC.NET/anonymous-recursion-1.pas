function Fib(n: integer): integer;
begin
  if n <= 0 then
    raise new System.ArgumentOutOfRangeException('Must be > 0','n');
  var fibHelper: (integer,integer,integer) -> integer;
  fibHelper := (n,a,b) -> n = 1 ? a : fibHelper(n-1, b, a + b);
  Result := fibHelper(n,1,1);
end;

begin
  for var i:=1 to 10 do
    Fib(i).Print;
end.
