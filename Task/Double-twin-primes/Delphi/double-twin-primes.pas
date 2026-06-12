function IsPrime(N: integer): boolean;
{Fast, optimised prime test}
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

procedure ShowDoubleTwinPrimes(Memo: TMemo);
{Find sets of four primes P1,P2,P3,P4, where}
{P2-P1=2 P4-P3=2 and P3-P2=4 }
{Use TList as FIFO to test all four-prime combinations}
var LS: TList;
var Start: integer;
begin
LS:=TList.Create;
try
Start:=0;
while true do
	begin
	{Put four primes in the list}
	repeat LS.Add(Pointer(GetNextPrime(Start)))
	until LS.Count=4;
	if Integer(LS[3])>=1000 then break;
	{Test if they are double twin prime}
	if (Integer(LS[1])-Integer(LS[0])=2) and
	   (Integer(LS[3])-Integer(LS[2])=2) and
	   (Integer(LS[2])-Integer(LS[1])=4) then
	   	begin
	   	{Display the result}
	   	Memo.Lines.Add(IntToStr(Integer(LS[0]))+' '+
			IntToStr(Integer(LS[1]))+' '+
			IntToStr(Integer(LS[2]))+' '+
			IntToStr(Integer(LS[3])));
		end;
	{Delete the first prime}
	LS.Delete(0);
	end;
finally LS.Free; end;
end;

