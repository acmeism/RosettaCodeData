procedure GetDigits(N: integer; var IA: TIntegerDynArray);
{Get an array of the integers in a number}
var T: integer;
begin
SetLength(IA,0);
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=T;
	end
until N<1;
end;


function HasEqualRiseFall(N: integer): boolean;
{Count rises and falls in numbers left to Right}
var I: integer;
var IA: TIntegerDynArray;
var Rise,Fall: integer;
begin
Rise:=0; Fall:=0;
GetDigits(N,IA);
for I:=High(IA) downto 1 do
 if IA[I-1]>IA[I] then Inc(Rise)
 else if IA[I-1]<IA[I] then Inc(Fall);
Result:=Rise=Fall;
end;


procedure ShowEqualRiseFall(Memo: TMemo);
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=1 to High(integer) do
 if HasEqualRiseFall(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%4.0d', [I]);
	if (Cnt mod 20)=0 then S:=S+CRLF;
	if Cnt=200 then break;
	end;
Memo.Text:=S;
Memo.Lines.Add('Count = '+IntToStr(Cnt));

for I:=1 to High(integer) do
 if HasEqualRiseFall(I) then
	begin
	Inc(Cnt);
	if Cnt>=10000000 then
		begin
		Memo.Lines.Add('10-Million: '+IntToStr(I));
		break;
		end;
	end;
end;
