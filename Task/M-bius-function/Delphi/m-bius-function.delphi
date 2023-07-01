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



function GetNextPrime(var Start: integer): integer;
{Get the next prime number after Start}
{Start is passed by "reference," so the
{original variable is incremented}
begin
repeat Inc(Start)
until IsPrime(Start);
Result:=Start;
end;


type TIntArray = array of integer;


procedure StoreNumber(N: integer; var IA: TIntArray);
{Expand and store number in array}
begin
SetLength(IA,Length(IA)+1);
IA[High(IA)]:=N;
end;


procedure GetPrimeFactors(N: integer; var Facts: TIntArray);
{Get all the prime factors of a number}
var I: integer;
begin
I:=2;
repeat
	begin
	if (N mod I) = 0 then
		begin
		StoreNumber(I,Facts);
		N:=N div I;
		end
	else GetNextPrime(I);
	end
until N=1;
end;



function HasDuplicates(IA: TIntArray): boolean;
{Look for duplicates factors in array}
var I: integer;
begin
Result:=True;
for I:=0 to Length(IA)-1 do
 if IA[I]=IA[I+1] then exit;
Result:=False;
end;


function Moebius(N: integer): integer;
{Get moebius function of number}
var I: integer;
var Factors: TIntArray;
var Even,Square: boolean;
begin
{Collect all prime factors}
SetLength(Factors,0);
GetPrimeFactors(N,Factors);
{Are there an even number of factors?}
Even:=(Length(Factors) and 1)=0;
{If there are duplicates, there are perfect squares}
Square:=HasDuplicates(Factors);
{Return the Moebius function value}
if Square then Result:=0
else if Even then Result:=1
else Result:=-1;
end;

procedure TestMoebiusFactors(Memo: TMemo);
{Test Moebius function for 1..200-1}
var N,M: integer;
var S: string;
begin
S:='';
for N:=1 to 199 do
	begin
	M:=Moebius(N);
	S:=S+Format('%3d',[M]);
	if (N mod 20)=19 then S:=S+#$0D#$0A
	end;
Memo.Text:=S;
end;
