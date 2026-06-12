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



procedure QuadratSpecialPrimes(Memo: TMemo);
var Q,P,Cnt: integer;
var IA: TIntegerDynArray;
begin
Memo.Lines.Add('Count Prime1  Prime2    Gap  Sqrt');
Memo.Lines.Add('---------------------------------');
Cnt:=0;
Q:=2;
for P:=3 to 16000-1 do
 if IsPrime(P) then
	begin
	if frac(sqrt(P - Q))=0 then
		begin
		Inc(Cnt);
		Memo.Lines.Add(Format('%5D%7D%8D%7D%6.1f',[Cnt,Q,P,P-Q,Sqrt(P-Q)]));
		Q:=P;
		end;
	end;
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;


