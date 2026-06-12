function IsSubstringPrime(N: integer): boolean;
begin
if not IsPrime(N) then Result:=False
else if n < 10 then Result:=True
else if not IsPrime(N mod 100) then Result:=False
else if not IsPrime(N mod 10) then Result:=False
else if not IsPrime(N div 10) then Result:=False
else if n < 100 then Result:=True
else if not IsPrime(N div 100) then Result:=False
else if not IsPrime((N mod 100) div 10) then Result:=False
else Result:=True;
end;

procedure ShowSubtringPrimes(Memo: TMemo);
var N: integer;
begin
for N:=2 to 500-1 do
 if IsSubstringPrime(N) then Memo.Lines.Add(IntToStr(N));
end;


