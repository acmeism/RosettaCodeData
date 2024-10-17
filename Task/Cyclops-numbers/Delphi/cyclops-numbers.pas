var Base: integer;	{Base value for iterating through cyclops numbers}
var OutStr: string;	{Hold accumulating output data}


function NumberOfDigits(N: integer): integer;
{Find the number of digits in an integer}
begin
if N<1 then Result:=0
else Result:=Trunc(Log10(N))+1;
end;


procedure OutputNumber(Memo: TMemo; N: integer);
{Output number, grouping them 10 items per line}
begin
OutStr:=OutStr+Format('%8D',[N]);
if ((Length(OutStr) div 8) mod 10)=0 then
	begin
	Memo.Lines.Add(OutStr);
	OutStr:='';
	end;
end;

function IsPrime(N: integer): boolean;
{Optimised prime test - about 40% faster than the naive approach}
var I,Stop: integer;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
	begin
	I:=5;
	Stop:=Trunc(sqrt(N));
	Result:=False;
	while I<=Stop do
		begin
		if ((N mod I) = 0) or ((N mod (i + 2)) = 0) then exit;
		Inc(I,6);
		end;
	Result:=True;
	end;
end;

function NonZeroIncrement(N: integer): integer;
{Find next number with no zero digits}
begin
repeat Inc(N)
until Pos('0',IntToStr(N))<1;
Result:=N;
end;


function GetNonZeroEvenDigits(N: integer): integer;
{Get next number with no zeros that has even number of digits}
begin
repeat N:=NonZeroIncrement(N)
until (NumberOfDigits(N) and 1)=0;
Result:=N;
end;



function InsertCenterZero(N: integer): integer;
{Insert a zero in the centers of a number}
{assumes the number is an even number digits long}
var S: string;
begin
S:=IntToStr(N);
Insert('0',S,(Length(S) div 2)+1);
Result:=StrToInt(S);
end;


function GetNextCyclops: integer;
{Get next cyclops number}
begin
Base:=GetNonZeroEvenDigits(Base);
Result:=InsertCenterZero(Base);
end;



function GetPalindromeCyclops: integer;
{Get next palindromic cyclops number}
var S1,S2: string;
begin
Base:=NonZeroIncrement(Base);
S1:=IntToStr(Base);
S2:=ReverseString(S1);
Result:=StrToInt(S1+'0'+S2);
end;


{--------------- Top level routines -------------------------------------------}

procedure GetCyclopsNumbers(Memo: TMemo);
{find first 50 Prime Cyclcops Numbers}
var I,C: integer;
var S: string;
begin
Memo.Lines.Add('First 50 Cyclops Numbers');
Base:=0;
OutputNumber(Memo,0);
for I:=1 to 50-1 do
	begin
	C:=GetNextCyclops;
	OutputNumber(Memo,C);
	end;
if OutStr<>'' then Memo.Lines.Add(OutStr);
end;


procedure GetPrimeCyclops(Memo: TMemo);
{find first 50 Prime Cyclcops Numbers}
var I,C: integer;
var S: string;
begin
Memo.Lines.Add('First 50 Prime Cyclops Numbers');
Base:=0;
for I:=1 to 50 do
	begin
	repeat C:=GetNextCyclops;
	until IsPrime(C);
	OutputNumber(Memo,C);
	end;
if OutStr<>'' then Memo.Lines.Add(OutStr);
end;


procedure GetBlindPrimeCyclops(Memo: TMemo);
{find first 50 Blind Prime Cyclcops Numbers}
var I,C,CB: integer;
var S: string;
begin
Memo.Lines.Add('First 50 Blind Prime Cyclops Numbers');
Base:=0;
for I:=1 to 50 do
	begin
	repeat C:=GetNextCyclops;
	until IsPrime(Base);
	OutputNumber(Memo,C);
	end;
if OutStr<>'' then Memo.Lines.Add(OutStr);
end;


procedure GetPalindromicPrimeCyclops(Memo: TMemo);
{find first 50 Palindromic Prime Cyclcops Numbers}
var I,C,CB: integer;
var S: string;
begin
Memo.Lines.Add('First 50 Palindromic Prime Cyclops Numbers');
Base:=0;
for I:=1 to 50 do
	begin
	repeat C:=GetPalindromeCyclops;
	until IsPrime(C);
	OutputNumber(Memo,C);
	end;
if OutStr<>'' then Memo.Lines.Add(OutStr);
end;




procedure DisplayCyclopsNumbers(Memo: TMemo);
{Do full suite of Cyclops tasks}
begin
GetCyclopsNumbers(Memo);
GetPrimeCyclops(Memo);
GetBlindPrimeCyclops(Memo);
GetPalindromicPrimeCyclops(Memo);
end;
