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


function IsPalindrome(N, Base: integer): boolean;
{Test if number is the same forward or backward}
{For a specific Radix}
var S1,S2: string;
begin
S1:=GetRadixString(N,Base);
S2:=ReverseString(S1);
Result:=S1=S2;
end;

function IsPalindrome2416(N: integer): boolean;
{Is N palindromic for bases 2, 4 and 16}
begin
Result:=IsPalindrome(N,2) and
	IsPalindrome(N,4) and
	IsPalindrome(N,16);
end;

procedure ShowPalindrome2416(Memo: TMemo);
{Show all numbers Palindromic for bases 2, 4 and 16}
var S: string;
var I,Cnt: integer;
begin
S:='';
Cnt:=0;
for I:=0 to 25000-1 do
 if IsPalindrome2416(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add('Count='+IntToStr(Cnt));
Memo.Lines.Add(S);
end;

