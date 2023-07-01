function GetRadixString(L: int64; Radix: Byte): string;
{Converts integer a string of any radix}
const RadixChars: array[0..35] Of char =
    ('0', '1', '2', '3', '4', '5', '6', '7',
     '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
     'G','H', 'I', 'J', 'K', 'L', 'M', 'N',
     'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
     'W', 'X', 'Y', 'Z');
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
	S:=RadixChars[I] + S;
	L:=L div Radix;
	end
until L = 0;
Result:=Sign + S;
end;


function HasUniqueDigits(N: int64; Base: integer): boolean;
{Keep track of unique digits with bits in a mask}
var Mask,Bit: cardinal;
var I,Cnt: integer;
begin
Cnt:=0; Mask:=0;
repeat
	begin
	I:=N mod Base;
	Bit:=1 shl I;
	if (Bit and Mask)=0 then
		begin
		Mask:=Mask or Bit;
		Inc(Cnt);
		end;
	N:=N div Base;
	end
until N = 0;
Result:=Cnt=Base;
end;


function GetStartValue(Base: integer): Int64;
{Start with the first N-Digit number in the base}
var I: integer;
begin
Result:=1;
for I:=1 to Base-1 do Result:=Result*Base;
Result:=Trunc(Sqrt(Result+0.0))-1;
end;


function FindFirstSquare(Base: integer): int64;
{Test squares to find the first one with unique digits}
var Start: int64;
begin
Result:=GetStartValue(Base);
while Result<=high(integer) do
	begin
	if HasUniqueDigits(Result*Result,Base) then break;
	Inc(Result);
	end;
end;


procedure ShowFirstSquares(Memo: TMemo);
{Find and display first perfect square that uses all digits in bases 2-16}
var I: integer;
var N: int64;
var S1,S2: string;
begin
for I:=2 to 16 do
	begin
	N:=FindFirstSquare(I);
	S1:=GetRadixString(N,I);
	S2:=GetRadixString(N*N,I);
	Memo.Lines.Add(Format('Base=%2d   %14s^2 = %16s',[I,S1,S2]));
	end;
end;
