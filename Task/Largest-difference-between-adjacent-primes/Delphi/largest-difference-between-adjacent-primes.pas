function IsPrime(N: integer): boolean;
{Optimised prime test - about 40% faster than the naive approach}
var I,Stop: integer;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
	begin
	I:=5;
	Stop:=Trunc(sqrt(N));
	Result:=False;
	while I<=Stop do
		begin
		if ((N mod I) = 0) or ((N mod (i + 2)) = 0) then exit;
		Inc(I,6);
		end;
	Result:=True;
	end;
end;



procedure LargestPrimeDifference(Memo: TMemo);
{Find the largest difference between primes under 1 million}
var I: integer;
var P1,P2: integer;
var Delta,Largest,Prime1,Prime2: integer;
begin
Largest:=0;
P1:=1;
for I:=1 to 1000000-1 do
 if IsPrime(I) then
	begin
	Delta:=I - P1;
	if Delta>Largest then
		begin
		Largest:=Delta;
		Prime1:=P1;
		Prime2:=I;
		end;
	P1:=I;
	end;
Memo.Lines.Add(Format('Prime1: %d  Prime2: %d    Diff:  %d',[Prime1,Prime2,Largest]));
end;


