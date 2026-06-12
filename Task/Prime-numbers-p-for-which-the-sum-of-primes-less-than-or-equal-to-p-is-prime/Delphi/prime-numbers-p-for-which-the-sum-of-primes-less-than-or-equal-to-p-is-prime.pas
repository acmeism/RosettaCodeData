procedure ShowPrimeLesserSum(Memo: TMemo);
var N,Sum,Cnt: integer;
var S: string;
begin
Cnt:=0;
Sum:=0;
for N:=2 to 1000-1 do
 if IsPrime(N) then
	begin
	Sum:=Sum+N;
	if IsPrime(Sum) then
		begin
		Inc(Cnt);
		S:=S+Format('%4d',[N]);
		If (Cnt mod 5)=0 then S:=S+CRLF;
		end;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Cnt));
end;


