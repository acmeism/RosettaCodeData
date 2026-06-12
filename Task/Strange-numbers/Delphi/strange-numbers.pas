{This code is normally in a separate library, but it is included here for clarity}

procedure GetDigits(N: integer; var IA: TIntegerDynArray);
{Get an array of the integers in a number}
{Numbers returned from least to most significant}
var T,I,DC: integer;
begin
DC:=Trunc(Log10(N))+1;
SetLength(IA,DC);
for I:=0 to DC-1 do
	begin
	T:=N mod 10;
	N:=N div 10;
	IA[I]:=T;
	end;
end;

function IsStrangeNumber(N: integer): boolean;
{Test if the difference between digits is prime}
var Digits: TIntegerDynArray;
var I: integer;
begin
Result:=False;
{Get digits}
GetDigits(N,Digits);
{test if the difference between digits is prime}
for I:=0 to High(Digits)-1 do
 if not IsPrime(abs(Digits[I+1]-Digits[I])) then exit;
Result:=True
end;


procedure ShowStrangeNumbers(Memo: TMemo);
var I,Cnt: integer;
var S: string;
begin
S:='';
Cnt:=0;
for I:=100 to 500-1 do
 if IsStrangeNumber(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%5d',[I]);
	if (Cnt mod 10)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add('Count = '+IntToStr(Cnt));
Memo.Lines.Add(S);
end;


