function GetGoldbachCount(N: integer): integer;
{Count number of prime number combinations add up to N }
var I: integer;
begin
Result:=0;
{Look at all number pairs that add up to N}
{And see if they are prime}
for I:=1 to N div 2 do
 if IsPrime(I) and IsPrime(N-I) then Inc(Result);
end;

procedure ShowGoldbachComet(Memo: TMemo);
{Show first 100 Goldback numbers}
var I,N,Cnt,C: integer;
var S: string;
begin
Cnt:=0; N:=2; S:='';
while true do
	begin
	C:=GetGoldbachCount(N);
	if C>0 then
		begin
		Inc(Cnt);
		S:=S+Format('%3d',[C]);
		if (Cnt mod 10)=0 then S:=S+CRLF;
		if Cnt>=100 then break;
		end;
	Inc(N,2);
	end;
Memo.Lines.Add(S);
end;
