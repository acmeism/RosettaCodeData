function IntToBinStr(IValue: Int64) : string;
{Convert integer to binary string, with no leading zero}
var I: integer;
begin
Result:='';
I:=IntPower2(32-1);
while I <> 0 do
	begin
	if (IValue and I)<>0 then Result:=Result + '1'
	else if Length(Result)>0 then Result:=Result + '0';
	I:=I shr 1;
	end;
if Result='' then Result:='0';
end;


procedure IdenticalBinaryStrings(Memo: TMemo);
var S,S1,S2: string;
var Len,I: integer;
begin
for I:=2 to 1000-1 do
	begin
	{Get binary String}
	S:=IntToBinStr(I);
	{Only look at string evenly divisible by 2}
	Len:=Length(S);
	if (Len and 1)=0 then
		begin
		{Split string into equal pieces}
		S1:=LeftStr(S,Len div 2);
		S2:=RightStr(S,Len div 2);
		{Each half should be the same}
		if S1=S2 then Memo.Lines.Add(IntToStr(I)+': '+S);
		end;
	end;
end;



