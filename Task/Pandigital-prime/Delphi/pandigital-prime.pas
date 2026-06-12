{This code is normally put in a separate library, but it is included here for clarity}

function IsPrime(N: int64): boolean;
{Fast, optimised prime test}
var I,Stop: int64;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
     begin
     I:=5;
     Stop:=Trunc(sqrt(N+0.0));
     Result:=False;
     while I<=Stop do
           begin
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;




function HighestPandigitalPrime(ZeroBased: boolean): integer;
{Returns the highest pandigital prime}
{ZeroBased = includes 0..N versus 1..N }
var I: integer;

	type TDigitFlagArray = array [0..9] of integer;

	procedure GetDigitCounts(N: integer; var FA: TDigitFlagArray);
	{Get a count of all the digits in the number}
	var T,I,DC: integer;
	begin
	DC:=Trunc(Log10(N))+1;
	{Zero counts}
	for I:=0 to High(FA) do FA[I]:=0;
	{Count each time a digits is used}
	for I:=0 to DC-1 do
		begin
		T:=N mod 10;
		N:=N div 10;
		Inc(FA[T]);
		end;
	end;

	function IsPandigital(N: integer): boolean;
	{Checks to see if all digits 0..N or 1..N are included}
	var IA: TDigitFlagArray;
	var I,DC: integer;
	var Start: integer;
	begin
	Result:=False;
	{ZeroBased includes zero}
	if ZeroBased then Start:=0 else Start:=1;
	{Get count of digits}
	DC:=Trunc(Log10(N))+1;
	{Get a count of each digits that are used}
	GetDigitCounts(N,IA);
	{Each digit 0..N or 1..N can only be used once}
	for I:=Start to DC-1 do
	 if IA[I]<>1 then exit;
	Result:=True;
	end;

begin
if ZeroBased then Result:=76543210+1 else Result:=7654321;
{Check all numbers in the range}
while Result>2 do
	begin
	{Check that number is prime and Pandigital}
	if IsPrime(Result) then
	 if IsPandigital(Result) then break;
	Dec(Result,2);
	end;
end;



procedure PandigitalPrime(Memo: TMemo);
var P: integer;
begin
P:=HighestPandigitalPrime(False);
Memo.Lines.Add(Format('Non Zero Based: %11.0n',[P+0.0]));
P:=HighestPandigitalPrime(True);
Memo.Lines.Add(Format('Zero Based:     %11.0n',[P+0.0]));
end;

