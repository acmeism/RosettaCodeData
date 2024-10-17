function GetRadixString(L: Integer; Radix: Byte): string;
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

procedure ShowRadixConvertion(Memo: TMemo);
var B,N: integer;
var S,RS: string;
begin
N:=6502;
for B:=2 to 23 do
	begin
	RS:=GetRadixString(N,B);
	RS:=LowerCase(RS);
	Memo.Lines.Add(Format('%5d -> base: %3D = %15S',[N,B,RS]));
	end;
end;
