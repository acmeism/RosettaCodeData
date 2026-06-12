procedure StoreNumber(N: integer; var IA: TIntegerDynArray);
{Expand and store number in array}
begin
SetLength(IA,Length(IA)+1);
IA[High(IA)]:=N;
end;


procedure GetPrimeFactors(N: integer; var Facts: TIntegerDynArray);
{Get all the prime factors of a number}
var I: integer;
begin
I:=2;
SetLength(Facts,0);
repeat
	begin
	if (N mod I) = 0 then
		begin
		StoreNumber(I,Facts);
		N:=N div I;
		end
	else I:=GetNextPrime(I);
	end
until N=1;
end;



procedure ProductMinMaxFactors(Memo: TMemo);
var I,Cnt,P: integer;
var IA: TIntegerDynArray;
var S: string;
begin
Cnt:=1;
S:='    1';
for I:=2 to 100 do
	begin
	GetPrimeFactors(I,IA);
	P:=IA[0] * IA[High(IA)];
	Inc(Cnt);
	S:=S+Format('%5D',[P]);
	If (Cnt mod 10)=0 then S:=S+CRLF;
	 end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;

