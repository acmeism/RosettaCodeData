function Fib(n: integer): integer;
  function fibHelper(n,a,b: integer): integer :=
    n = 1 ? a : fibHelper(n-1, b, a + b);
begin
  if n <= 0 then
    raise new System.ArgumentOutOfRangeException('Must be > 0','n');
  Result := fibHelper(n,1,1);
end;

begin
  for var i:=1 to 10 do
    Fib(i).Print;
end.
