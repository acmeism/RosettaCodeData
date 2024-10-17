{-------------Library Routines ----------------------------------------------------------------}
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

function GetNKPalindrome(N,K: int64): int64;
{Get Nth Palindrome with K-number of digits}
{N = Left half, Right = Reversed(left) a  }
var Temp,H1,H2,I: int64;
begin
{Get left digit count - depends on K being odd/even}
if (K and 1)<>0 then Temp:=K div 2 else Temp:=K div 2 - 1;
{Get power of 10 digits}
H1:=trunc(Power(10, Temp));
{Add in N}
H1:=H1 + N - 1;
H2:=H1;
{ If K is odd, truncate the last digit}
if (k and 1)<>0 then H2:=H2 div 10;
{Reverse H2 and add to H1}
while H2>0 do
	begin
	H1:=H1 * 10 + (H2 mod 10);
	H2:=H2 div 10;
	end;
Result:=H1;
end;



function GetPalDigits(N: int64; var Offset: int64): integer;
{Get number of digits and offset for Nth Palindrome}
{Used to feed GetNKPalindrome to find Nth Palindrome}
var R1,R2,Step: int64;
begin
R1:=0;
{Step through number of digits}
for Result:=1 to 36 do
	begin
	{Calculate new Range step: 9,9,90,90,90,900,900...}
	if (Result and 1)<>0 then Step:=9 * Trunc(Power(10,Result div 2));
	{Calculate R2}
	R2:=(R1 + Step)-1;
	{See if N falls between R1 and R2}
	if (N>=R1) and (N<=R2) then
		begin
		{Calculate offset and exit}
		Offset:=(N - R1)+1;
		exit;
		end;
	R1:=R2+1;
	end;
end;


function GetNthPalindrome(N: integer): int64;
{Get the Nth Palindrome number}
var D,Off: int64;
begin
D:=GetPalDigits(N,Off);
Result:=GetNKPalindrome(Off,D);
end;



procedure GetPalindromeList(Count: integer; var Pals: TInt64DynArray);
{Get a list of the first "Count"-number of palinedromes (Fast)}
var D,I,Inx,Max: integer;
begin
{Set array length}
SetLength(Pals,Count);
Inx:=0;
{Handle palindromes up to 18 digits}
for D:=1 to 18 do
	begin
	{Get maximum count for palindrom of D digits}
	if (D and 1)=1 then Max:=Trunc(Power(10,(D + 1) div 2))
	else Max:=Trunc(Power(10,D div 2));
	{Step through all the numbers half the size of the number of digits}
	for I:=1 to Max-Max div 10 do
		begin
		{Store palindrome}
		Pals[Inx]:=GetNKPalindrome(I,D);
		Inc(Inx);
		{Exit when array is full}
		if Inx>=Count then break;
		end;
	end;
end;


{------------------------------------------------------------------------------------------------}


function IsGapful(N: int64): boolean;
{Return true if number is "GapFul"}
{GapFul = combined first/last}
{ digits divide evenly into N}
var Digits: TIntegerDynArray;
var I: int64;
begin
Result:=False;
{Must be 3 digit number}
if N<100 then exit;
{Put digits in array}
GetDigits(N,Digits);
{Form number from first and last digit}
I:=Digits[0] + 10 * Digits[High(Digits)];
{Does it divide evenly into N}
Result:=(N mod I)=0;
end;


function HasEndDigit(N: int64; Digit: integer): boolean;
{Return true if last digit match specified "Digit"}
var LD: integer;
begin
LD:=N mod 10;
Result:=LD=Digit;
end;


function GetGapfulPalinEndSet(Max, EndDigit: integer): string;
{Get first Max number of Gapful Palindromes with specified EndDigit}
var I,Cnt,P: integer;
begin
Result:='Ending in: '+IntToStr(EndDigit)+CRLF;
Cnt:=0;
{Get palindromes and test them}
for I:=0 to high(Integer) do
	begin
	{Get next palinedrome}
	P:=GetNthPalindrome(I);
	{Is Gapful and has specified EndDigit}
	if IsGapFul(P) and HasEndDigit(P,EndDigit) then
		begin
		Inc(Cnt);
		{Display it}
		Result:=Result+Format('%8d',[P]);
		if (Cnt mod 5)=0 then Result:=Result+CRLF;
		{Break when finished}
		if Cnt>=Max then break;
		end;
	end;
end;



function LastGapfulPalinEndSet(Count,Last,EndDigit: integer): string;
{Get Gapful Palindromes with specified EndDigit}
{Get "Last" number of items out of a total "Count" }
var I,Inx: integer;
var P: int64;
var IA: TInt64DynArray;
begin
SetLength(IA,Count);
Result:='Ending in: '+IntToStr(EndDigit)+CRLF;
{Get count number of items}
Inx:=0;
for I:=0 to Count-1  do
	begin
	{Keep getting palindromes until}
	{they Gapful and have specified last digit}
	repeat
		begin
		P:=GetNthPalindrome(Inx);
		Inc(Inx);
		end
	until IsGapFul(P) and HasEndDigit(P,EndDigit);
	{Save item}
	IA[I]:=P;
	end;
{Get last items}
for I:=Count-Last to Count-1 do
	begin
	Result:=Result+Format('%12d',[IA[I]]);
	if (I mod 5)=4 then Result:=Result+CRLF;
	end;
end;



procedure ShowPalindromicGapfuls(Memo: TMemo);
var S: string;
begin
Memo.Lines.Add('First 20 palindromic gapful numbers');

Memo.Lines.Add(GetGapFulPalinEndSet(20,1));
Memo.Lines.Add(GetGapFulPalinEndSet(20,2));
Memo.Lines.Add(GetGapFulPalinEndSet(20,3));
Memo.Lines.Add(GetGapFulPalinEndSet(20,4));
Memo.Lines.Add(GetGapFulPalinEndSet(20,5));
Memo.Lines.Add(GetGapFulPalinEndSet(20,6));
Memo.Lines.Add(GetGapFulPalinEndSet(20,7));
Memo.Lines.Add(GetGapFulPalinEndSet(20,8));
Memo.Lines.Add(GetGapFulPalinEndSet(20,9));

Memo.Lines.Add('86th to 100th');
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,1));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,2));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,3));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,4));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,5));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,6));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,7));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,8));
Memo.Lines.Add(LastGapFulPalinEndSet(100,15,9));

Memo.Lines.Add('991st to 1000th:');
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,1));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,2));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,3));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,4));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,5));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,6));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,7));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,8));
Memo.Lines.Add(LastGapFulPalinEndSet(1000,10,9));
end;
