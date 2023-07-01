function IntPower(N,P: integer): integer;
var I: integer;
begin
Result:=N;
for I:=1 to P-1 do Result:=Result * N;
end;

function IsNarcisNumber(N: integer): boolean;
{Test if this a narcisstic number}
{i.e. the sum of each digit raised to power length = N}
var S: string;
var I,Sum,B,P: integer;
begin
S:=IntToStr(N);
Sum:=0;
P:=Length(S);
for I:=1 to Length(S) do
	begin
	B:=byte(S[I])-$30;
	Sum:=Sum+IntPower(B,P);
	end;
Result:=Sum=N;
end;


procedure ShowNarcisNumber(Memo: TMemo);
{Show first 25 narcisstic number}
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=0 to High(Integer) do
 if IsNarcisNumber(I) then
	begin
	S:=S+Format('%10d',[I]);
	Inc(Cnt);
	if (Cnt mod 5)=0 then S:=S+#$0D#$0A;
	if Cnt>=25 then break;
	end;
Memo.Lines.Add(S);
end;
