function FindProperDivisor(N: Integer): integer;
{Find the highest proper divisor}
{i.e. The highest number that evenly divides in N}
begin
if N=1 then Result:=1
else for Result:=N-1 downto 1 do
 if (N mod Result)=0 then break;
end;



procedure AllProperDivisors(Memo: TMemo);
{Show all proper divisors for number 1..100}
var I: integer;
var S: string;
begin
S:='';
for I:=1 to 100 do
	begin
	S:=S+Format('%3d',[FindProperDivisor(I)]);
	if (I mod 10)=0 then S:=S+#$0D#$0A;
	end;
Memo.Text:=S;
end;
