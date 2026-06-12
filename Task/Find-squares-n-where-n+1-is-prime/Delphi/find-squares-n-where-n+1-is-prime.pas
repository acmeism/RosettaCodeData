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


procedure ShowPrimeSquares(Memo: TMemo);
var N,S2: integer;
begin
for N:= 1 to Trunc(sqrt(1000-1)) do
	begin
	S2:=N*N;
	if IsPrime(S2+1) then Memo.Text:=Memo.Text+' '+IntToStr(S2);
	end;
end;

