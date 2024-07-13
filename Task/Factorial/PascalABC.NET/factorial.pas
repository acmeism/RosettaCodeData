function FactIter(n: integer): BigInteger;
begin
  Result := 1;
  for var i:=2 to n do
    Result *= i;
end;

function FactRec(n: integer): BigInteger;
begin
  if n = 0 then
    Result := 1
  else Result := n * FactRec(n - 1);
end;


begin
  for var i:=1 to 20 do
    Println(i,FactRec(i),FactIter(i));
end.
