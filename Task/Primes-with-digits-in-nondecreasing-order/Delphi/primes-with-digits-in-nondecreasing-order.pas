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



procedure NonDecreasingPrime(Memo: TMemo);
var I,Cnt: integer;
var IA: TIntegerDynArray;
var S: string;

	function NotDecreasing(N: integer): boolean;
	var I: integer;
	begin
	Result:=False;
	GetDigits(N,IA);
	for I:=0 to High(IA)-1 do
	 if IA[I]<IA[I+1] then exit;
	Result:=True;
	end;

begin
Cnt:=0;
S:='';
for I:=0 to 1000-1 do
 if IsPrime(I) then
  if NotDecreasing(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%5D',[I]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	 end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;


