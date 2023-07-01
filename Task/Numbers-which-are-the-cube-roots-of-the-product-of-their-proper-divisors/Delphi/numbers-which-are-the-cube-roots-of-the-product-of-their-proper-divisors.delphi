function GetAllProperDivisors(N: Integer;var IA: TIntegerDynArray): integer;
{Make a list of all the "proper dividers" for N}
{Proper dividers are the of numbers the divide evenly into N}
var I: integer;
begin
SetLength(IA,0);
for I:=1 to N-1 do
 if (N mod I)=0 then
	begin
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=I;
	end;
end;

function CubeTest(N: int64): boolean;
{Test is N^3 = product of proper dividers}
var IA: TIntegerDynArray;
var P: int64;
var I: integer;
begin
GetAllProperDivisors(N,IA);
P:=1;
for I:=0 to High(IA) do P:=P * IA[I];
Result:=P=(N*N*N);
end;


procedure ShowCubeEqualsProper(Memo: TMemo);
{Show set the of N^3 = product of proper dividers}
var I,Cnt: integer;
var S: string;
begin
{Show the first 50}
Cnt:=0;
for I:=1 to High(Integer) do
 if CubeTest(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+#$0D#$0A;
	if Cnt>=50 then break;
	end;
Memo.Lines.Add(S);
{Show 500th, 5,000th and 50,000th}
Cnt:=0;
for I:=1 to High(Integer) do
 if CubeTest(I) then
	begin
	Inc(Cnt);

	if Cnt=500 then Memo.Lines.Add('500th = '+IntToStr(I));
	if Cnt=5000 then Memo.Lines.Add('5,000th = '+IntToStr(I));
	if Cnt=50000 then
		begin
		Memo.Lines.Add('50,000th = '+IntToStr(I));
		break;
		end;
	end;
end;
