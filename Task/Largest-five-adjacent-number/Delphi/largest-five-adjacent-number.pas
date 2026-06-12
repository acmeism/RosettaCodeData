function Get5DigitNumber(S: string; Off: integer): integer;
{Extract 5 digit number from string at Off}
var I: integer;
var NS: string;
begin
NS:=Copy(S,Off,5);
Result:=StrToIntDef(NS,-1);
end;



function BreakupString(S: string): string;
{Breakup thousand digit number for easy display}
var I: integer;
begin
for I:=1 to Length(S) do
 	begin
 	Result:=Result+S[I];
 	if (I mod 55)=0 then Result:=Result+#$0D#$0A;
 	end;
end;

procedure FiveDigitNumber(Memo: TMemo);
{Find the largest and small 5 digit sequence}
{in 1000 digit number}
var S: string;
var N,I: integer;
var Largest,Smallest: integer;
begin
Smallest:=High(Integer);
Largest:=0;
for I:=1 to 1000 do
 S:=S+Char(Random(10)+$30);
for I:=1 to Length(S)-5 do
	begin
	N:=Get5DigitNumber(S,I);
	if N>Largest then Largest:=N;
	if N<Smallest then Smallest:=N;
	end;
Memo.Lines.Add(BreakupString(S));
Memo.Lines.Add('Largest: '+IntToStr(Largest));;
Memo.Lines.Add('Smallest: '+IntToStr(Smallest));;
end;


