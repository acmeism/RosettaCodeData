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





procedure ShowPiprimes(Memo: TMemo);
var N, P, Cnt: integer;
var S: string;
begin
N:= 0;
P:= 1;
Cnt:= 0;
S:='';
repeat
   begin
   S:=S+Format('%3D',[N]);
   Inc(Cnt);
   if (Cnt mod 10)=0 then S:=S+CRLF;
   Inc(P);
        if IsPrime(P) then N:= N+1;
        end
until N >= 22;
Memo.Lines.Add(S);
end;

