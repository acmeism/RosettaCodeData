{Library routine included here for clarity}

function GetRadixString(L: int64; Radix: Byte): string;
{Converts integer a string of any radix}
const RadixChars: array[0..35] Of char =
    ('0', '1', '2', '3', '4', '5', '6', '7',
     '8', '9', 'A', 'B', 'C', 'D', 'E', 'F',
     'G','H', 'I', 'J', 'K', 'L', 'M', 'N',
     'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
     'W', 'X', 'Y', 'Z');
var I: cardinal;
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



function IsPenholoSquare(N: int64; Radix: byte): boolean;
{Test if N is a Penholodigital square}
var S: string;
var SL: TStringList;
var I: integer;
begin
Result:=False;
SL:=TStringList.Create;
try
{Get text version of number in the radix}
S:=GetRadixString(N,Radix);
{Reject any number with a zero in it}
if Pos('0',S)>0 then exit;
{Make sure string list doesn't duplicates}
SL.Sorted:=True;
SL.Duplicates:=dupIgnore;
{Insert each digit as one string in the list}
for I:=1 to Length(S) do SL.Add(S[I]);
{Same number of unique digits as radix-1? }
Result:=SL.Count=Radix-1;
finally SL.Free; end;
end;


function GetNDigitNumber(Digits,Radix: integer): extended;
{Get smallest N-digit number of specified radix}
begin
Result:=Power(10,(Digits-1) * Log(Radix));
end;


procedure GetStartStop(Radix: integer; var Start,Stop: int64);
{Start/Stop = Range of numbers to check}
{Since zero is not allowed, we want number width digits = Radix-1}
{Start/Stop squared = Smallest largest number that could match}
var S1,S2,Sqrt1,Sqrt2: extended;
begin
Start:=Trunc(Sqrt(GetNDigitNumber(Radix-1,Radix)));
Stop:=Trunc(Sqrt(GetNDigitNumber(Radix,Radix)-1));
end;


procedure FindAllPenholoSquares(Memo: TMemo; Radix: integer);
{Find all the Penholodigital squares for the specified radix}
var I,Start,Stop: int64;
var S,H: string;
var Cnt: integer;
begin
Cnt:=0;
{Get the range to look over}
GetStartStop(Radix,Start,Stop);
{Scan all the number for Penholodigital squares}
I:=Start;
while I<=Stop do
	begin
	if IsPenholoSquare(I*I,Radix) then
		begin
		Inc(Cnt);
		S:=S+GetRadixString(I,Radix)+'² = '+GetRadixString(I*I,Radix);
		if I<Stop then S:=S+'   ';
		If (Cnt mod 3)=0 then S:=S+CRLF;
		end;
	Inc(I);
	end;
H:=CRLF+'Penholodigital squares in base '+IntToStr(Radix)+CRLF;
H:=H+'Start: '+GetRadixString(Start,Radix)+'² = '+GetRadixString(Start*Start,Radix)+CRLF;
H:=H+'Stop:  '+GetRadixString(Stop,Radix)+'² = '+GetRadixString(Stop*Stop,Radix)+CRLF;
H:=H+'Count='+IntToStr(Cnt)+CRLF;
Memo.Lines.Add(H+S);
end;


procedure ShowPenholoSquares(Memo: TMemo);
{Show Penholodigital squares for various radices}
var N,C: int64;
begin
FindAllPenholoSquares(Memo,9);
FindAllPenholoSquares(Memo,10);
FindAllPenholoSquares(Memo,11);
FindAllPenholoSquares(Memo,12);
FindAllPenholoSquares(Memo,13);
FindAllPenholoSquares(Memo,14);
end;


