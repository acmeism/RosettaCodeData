procedure ShowOddSquareNumbers(Memo: TMemo);
var I,N: integer;
var Cnt: integer;
var S: string;
begin
Cnt:=0;
for I:=10 to trunc(sqrt(1000)) do
	begin
	N:=I * I;
	if ((N and 1)=1) then
		begin
		Inc(Cnt);
		S:=S+Format('%8D',[N]);
		If (Cnt mod 5)=0 then S:=S+CRLF;
		end;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Cnt));
end;


