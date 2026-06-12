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




procedure ShowTriple026Prime(Memo: TMemo);
var N,Sum,Cnt: integer;
var NS,S: string;
begin
Cnt:=0;
S:='';
for N:=1 to 5500-1 do
 if IsPrime(N) then
  if IsPrime(N+2) and IsPrime(N+6) then
	begin
	Inc(Cnt);
	S:=S+Format('%6d%6d%6d',[N,N+2,N+6]);
	S:=S+CRLF;
	end;
Memo.Lines.Add('     P   P+2   P+6');
Memo.Lines.Add('------------------');
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;

