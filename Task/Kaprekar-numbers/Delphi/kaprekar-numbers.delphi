function IsKaprekar(N: integer): boolean;
{Return true if N is a Kaperkar number}
var S,S1,S2: string;
var N1,N2,Sum: cardinal;
var Sp: integer;
begin
Result:=True;
if N=1 then exit;
{Convert N^2 to string}
S:=IntToStr(N * N);
{Try all different splits}
for Sp:=2 to Length(S) do
	begin
	{Split into two strings}
	S1:=Copy(S,1,Sp-1);
	S2:=Copy(S,Sp,(Length(S)-Sp)+1);
	{Convert to integers}
	N1:=StrToInt(S1);
	N2:=StrToInt(S2);
	{Zeros aren't allowed}
	if (N1=0) or (N2=0) then continue;
	{Test if sum matches original number}
	Sum:=N1 + N2;
	if Sum=N then exit;
	end;
Result:=False;
end;


procedure ShowKaprekarNumbers(Memo: TMemo);
{Find all Kaprekar numbers less than 10,000}
var S: string;
var I: integer;
begin
for I:=1 to 10000 do
	begin
	if IsKaprekar(I) then Memo.Lines.Add(IntToStr(I));
	end;
end;
