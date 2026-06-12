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


function GetLargestPrimeFact(N: int64): int64;
var J: int64;
begin
J:=3;
while not IsPrime(N) do
	begin
	if (N mod j) = 0 then N:=N div J;
	Inc(J,2);
	end;
Result:=N;
end;


procedure TestLargePrimeFact(Memo: TMemo);
var F: integer;
begin
F:=GetLargestPrimeFact(600851475143);
Memo.Lines.Add(IntToStr(F));
end;


