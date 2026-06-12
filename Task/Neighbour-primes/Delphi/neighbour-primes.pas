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



procedure ShowNeighborPrimes(Memo: TMemo);
var P1,P2,P3,Cnt: integer;
var S: string;
begin
Memo.Lines.Add('Count    P    Q   PQ+2');
Memo.Lines.Add('-----------------------');
Cnt:=0; P1:=1; P2:=1; S:='';
While P1< 500 do
	begin
	GetNextPrime(P2);
	P3:=P1 * P2 + 2;
	if IsPrime(P3) then
		begin
		Inc(Cnt);
		S:=S+Format('%5D %4D %4D %6D',[Cnt,P1,P2,P3]);
		S:=S+#$0D#$0A;
		end;
	P1:=P2;
	end;
Memo.Lines.Add(S);
end;


