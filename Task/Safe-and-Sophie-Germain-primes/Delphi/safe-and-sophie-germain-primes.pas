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



procedure SophieGermainPrimes(Memo: TMemo);
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
S:='';
for I:=0 to high(integer) do
 if IsPrime(I) then
  if IsPrime(2 * I + 1) then
	begin
	Inc(Cnt);
	S:=S+Format('%5D',[I]);
	if Cnt>=50 then break;
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;

