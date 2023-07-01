type TIntArray = array of integer;

function GetRadixString(L: Integer; Radix: Byte): string;
{Converts integer a string of any radix}
const HexChars: array[0..15] Of char =
    ('0', '1', '2', '3', '4', '5', '6', '7',
     '8', '9', 'A', 'B', 'C', 'D', 'E', 'F');
var I: integer;
var S: string;
var Sign: string[1];
begin
Result:='';
If (L < 0) then
	begin
	Sign:='-';
	L:=Abs(L);
	end
else Sign:='';
S:='';
repeat
	begin
	I:=L mod Radix;
	S:=HexChars[I] + S;
	L:=L div Radix;
	end
until L = 0;
Result:=Sign + S;
end;



procedure StrToInts(S: string; var IA: TIntArray);
{Convert numerical string of any radix and convert to numbers}
var I: integer;
begin
for I:=1 to Length(S) do
	begin
	SetLength(IA,Length(IA)+1);
	if S[I]<#$40 then IA[High(IA)]:=Byte(S[I])-$30
	else IA[High(IA)]:=(Byte(S[I])-$41)+10;
	end;
end;



function IsEsthetic(N: integer; Radix: byte): boolean;
{Check number to see if neighboring digits are no more than one differents.}
var I: integer;
var S: string;
var IA: TIntArray;
begin
Result:=False;
S:=GetRadixString(N,Radix);
StrToInts(S,IA);
for I:=0 to Length(IA)-2 do
 if Abs(IA[I+1]-IA[I])<>1 then exit;
Result:=True;
end;



function GetEstheticRange(Memo: TMemo; Range1,Range2,Count1,Count2,Base: integer): integer;
{Find an Esthetic number in the domain of Range and Counts specified}
var I,Cnt: integer;
var S: string;
begin
Cnt:=0; Result:=0;
S:='';
for I:=Range1 to Range2 do
 if IsEsthetic(I,Base) then
	begin
	Inc(Cnt);
	if (Cnt>=Count1) and (Cnt<=Count2) then
		begin
		Inc(Result);
		S:=S+' '+GetRadixString(I,Base);
		if (Result mod 10)=0 then S:=S+#$0D#$0A;
		end;
	if Cnt>=Count2 then break;
	end;
Memo.Lines.Add(S);
end;


procedure FindEstheticNumbers(Memo: TMemo);
{Find Esthetic numbers for Rosetta Code problem}
var Base,First,Last,Cnt: integer;
begin
for Base:=2 to 16 do
	begin
	First:=Base*4; Last:=Base*6;
	Memo.Lines.Add(Format('Base %2d: %2dth to %2dth esthetic numbers:',[Base,First,Last]));
	Cnt:=GetEstheticRange(Memo,0,High(Integer),First,Last,Base);
	Memo.Lines.Add('Count: '+IntToStr(Cnt));
	Memo.Lines.Add('');
	end;

Memo.Lines.Add('Base 10: esthetic numbers between 1000,9999');
Cnt:=GetEstheticRange(Memo,1000,9999,0,High(Integer),10);
Memo.Lines.Add('Count: '+IntToStr(Cnt));
Memo.Lines.Add('');

Memo.Lines.Add('Base 10: esthetic numbers between 100000000,130000000');
Cnt:=GetEstheticRange(Memo,100000000,130000000,0,High(Integer),10);
Memo.Lines.Add('Count: '+IntToStr(Cnt));
Memo.Lines.Add('');
end;
