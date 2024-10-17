function SumDigits(N: integer): integer;
{Sum the integers in a number}
var T: integer;
begin
Result:=0;
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	Result:=Result+T;
	end
until N<1;
end;


procedure MinimumMultipleM(Memo: TMemo);
{Find N's where DigitSum(N X M) = N.}
var N,M: integer;
var S: string;
begin
S:='';
for N:=1 to 70 do
 for M:=1 to High(integer) do
	begin
	if SumDigits(M * N) = N then
		begin
		S:=S+Format('%8d',[M]);
		if N mod 10 = 0 then S:=S+#$0D#$0A;
		break;
		end;
	end;
Memo.Lines.Add(S);
end;
