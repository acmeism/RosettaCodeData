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



function IsPalindrome(N, Base: integer): boolean;
{Test if number is the same forward or backward}
{For a specific Radix}
var S1,S2: string;
begin
S1:=GetRadixString(N,Base);
S2:=ReverseString(S1);
Result:=S1=S2;
end;


procedure ShowPalindromePrimes(Memo: TMemo);
var I: integer;
var Cnt: integer;
var S: string;
begin
Cnt:=0;
for I:=1 to 1000-1 do
 if IsPrime(I) then
  if IsPalindrome(I,10) then
	begin
	Inc(Cnt);
	S:=S+Format('%4D',[I]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count='+IntToStr(Cnt));
end;


