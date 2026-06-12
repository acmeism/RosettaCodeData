procedure ShowPrimesWith123(Memo: TMemo);
var N,Sum,Cnt1,Cnt2: integer;
var NS,S: string;
begin
Cnt1:=0;
Cnt2:=0;
Sum:=0;
for N:=123 to 1000000-1 do
 if IsPrime(N) then
	begin
	NS:=IntToStr(N);
	if Pos('123',NS)>0 then
		begin
		Inc(Cnt1);
		if N<100000 then
			begin
			Inc(Cnt2);
			S:=S+Format('%6d',[N]);
			If (Cnt2 mod 8)=0 then S:=S+CRLF;
			end;
		end;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count <   100,000 = '+IntToStr(Cnt2));
Memo.Lines.Add('Count < 1,000,000 = '+IntToStr(Cnt1));
end;


