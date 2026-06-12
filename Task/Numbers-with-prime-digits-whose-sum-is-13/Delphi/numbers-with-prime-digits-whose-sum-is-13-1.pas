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


procedure GetDigits(N: integer; var IA: TIntegerDynArray);
{Get an array of the integers in a number}
var T: integer;
begin
SetLength(IA,0);
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=T;
	end
until N<1;
end;


function IsPrimeDigitSum13(N: integer): boolean;
{Return true N's digits are prime and total 13}
var IA: TIntegerDynArray;
var I,Sum: integer;
begin
Result:=False;
GetDigits(N,IA);
for I:=0 to High(IA) do
 if not IsPrime(IA[I]) then exit;
Sum:=0;
for I:=0 to High(IA) do Sum:=Sum+IA[I];
Result:=Sum=13;
end;

procedure ShowPrimeDigitSum13(Memo: TMemo);
{Show numbers whose digits are prime and total 13}
var I,Cnt: integer;
var S: string;
begin
Cnt:=0;
for I:=1 to 999999 do
 if IsPrimeDigitSum13(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%8D',[I]);
	If (Cnt mod 5)=0 then S:=S+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;

