{These routines would normally be in libraries but are shown here for clarity}


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


function SumDigits(N: integer): integer;
{Sum the integers in a number}
var T: integer;
begin
Result:=0;
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	Result:=Result+T;
	end
until N<1;
end;





procedure ShowDigitSumPrime(Memo: TMemo);
var N,Sum,Cnt: integer;
var NS,S: string;
begin
Cnt:=0;
S:='';
for N:=1 to 500-1 do
 if IsPrime(N) then
	begin
	Sum:=SumDigits(N);
	if IsPrime(Sum) then
		begin
		Inc(Cnt);
		S:=S+Format('%6d',[N]);
		if (Cnt mod 8)=0 then S:=S+CRLF;
		end;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;
