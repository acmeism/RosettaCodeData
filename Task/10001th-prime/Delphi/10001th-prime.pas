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


function Find10001thPrime: integer;
{Return the 10,001th prime number}
var Count: integer;
begin
Count:=1;
Result:= 3;
while true do
	begin
	if IsPrime(Result) then Count:= Count+1;
	if Count=10001 then exit;
	Inc(Result,2);
	end;
end;
