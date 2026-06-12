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



procedure ShowFirstLast3Prime(Memo: TMemo);
var I,Cnt1,Cnt2: integer;
var IA: TIntegerDynArray;
var S: string;

	function FirstLast3(N: integer): boolean;
	var I: integer;
	begin
	GetDigits(N,IA);
	Result:=(IA[0]=3) and (IA[High(IA)]=3);
	end;

begin
Cnt1:=0; Cnt2:=0;
S:='';
for I:=0 to 1000000-1 do
 if IsPrime(I) then
  if FirstLast3(I) then
	begin
	Inc(Cnt1);
	if I<4000 then
	  	begin
	  	Inc(Cnt2);
	  	S:=S+Format('%5D',[I]);
	  	If (Cnt2 mod 5)=0 then S:=S+CRLF;
	  	end;
	 end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count < 1,000     = '+IntToStr(Cnt2));
Memo.Lines.Add('Count < 1,000,000 = '+IntToStr(Cnt1));
end;


