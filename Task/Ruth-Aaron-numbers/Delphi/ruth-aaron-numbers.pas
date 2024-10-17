{These routines would normally be in a library, but are shown here for clarity}

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



procedure StoreNumber(N: integer; var IA: TIntegerDynArray);
{Expand and store number in array}
begin
SetLength(IA,Length(IA)+1);
IA[High(IA)]:=N;
end;


procedure GetPrimeFactors(N: integer; var Facts: TIntegerDynArray);
{Get all the prime factors of a number}
var I: integer;
begin
I:=2;
SetLength(Facts,0);
repeat
	begin
	if (N mod I) = 0 then
		begin
		StoreNumber(I,Facts);
		N:=N div I;
		end
	else I:=GetNextPrime(I);
	end
until N=1;
end;


procedure GetPrimeDivisors(N: integer; var Facts: TIntegerDynArray);
{Get all unique prime factors of a number}
var I: integer;
begin
I:=2;
SetLength(Facts,0);
repeat
	begin
	if (N mod I) = 0 then
		begin
		StoreNumber(I,Facts);
		N:=N div I;
		while (N mod I) = 0 do N:=N div I;
		end
	else I:=GetNextPrime(I);
	end
until N=1;
end;

{------------------------------------------------------------}

procedure RuthAaronNumbers(Memo: TMemo; UseFactors: boolean);
var N,Sum1,Sum2,Cnt: integer;
var S: string;


	function GetFactorSum(N: integer): integer;
	{Get the sum of the prime factors or divisors}
	var IA: TIntegerDynArray;
	var I: integer;
	begin
	if UseFactors then GetPrimeFactors(N,IA)
	else GetPrimeDivisors(N,IA);
	Result:=0;
	for I:=0 to High(IA) do Result:=Result+IA[I];
	end;

begin
Cnt:=0;
S:='';
{Get first sum}
Sum1:=GetFactorSum(1);
for N:=1 to High(integer) do
	begin
	{Get next sum}
	Sum2:=GetFactorSum(N+1);
	{Look for matching sums = Ruth-Aaron numbers}
	if Sum1=Sum2 then
		begin
		Inc(Cnt);
		S:=S+Format('%6D',[N]);
		if Cnt>=30 then break;
		If (Cnt mod 10)=0 then S:=S+CRLF;
		end;
	Sum1:=Sum2;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;



procedure ShowRuthAaronNumbers(Memo: TMemo);
begin
Memo.Lines.Add('The first 30 Ruth-Aaron numbers using factors');
RuthAaronNumbers(Memo, True);
Memo.Lines.Add('The first 30 Ruth-Aaron numbers using divisors');
RuthAaronNumbers(Memo, False);
end;
