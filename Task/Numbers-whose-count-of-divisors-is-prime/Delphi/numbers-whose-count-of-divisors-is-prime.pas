procedure GetUniqueFactors(N: integer; var IA: TIntegerDynArray);
{Get unique factors of a number}
var I: integer;
begin
SetLength(IA,1);
for I:=2 to N do
 if (N mod I)=0 then
	begin
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=I;
	end;
end;


procedure ShowCountPrimes(Memo: TMemo);
{Count the number of Unique factors that are prime}
var I,C,Cnt: integer;
var IA: TIntegerDynArray;
var S: string;
begin
Cnt:=0; S:='';
for I:=1 to 100000-1 do
	begin
	GetUniqueFactors(I,IA);
	C:=Length(IA);
	if (C=2) or (not IsPrime(C)) then continue;
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add('Count='+IntToStr(Cnt));
Memo.Lines.Add(S);
end;


