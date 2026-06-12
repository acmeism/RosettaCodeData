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

procedure MersennePrimes(Memo: TMemo);
var N: integer;
var Mn: int64;
begin
Memo.Lines.Add('2^N-1          Prime');
Memo.Lines.Add('--------------------' );

for N:=1 to 32 do
	begin
	Mn:=(1 shl N)-1;
	if IsPrime(Mn) then
	Memo.Lines.Add(Format('2^%d-1 %14.0n',[N,Mn+0.0]));
	end;
end;

