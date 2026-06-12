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



procedure ShowPrimeWords(Memo: TMemo);
var I,N,Sum,Cnt: integer;
var NS,S: string;

	function IsPrimeWord(S: string): boolean;
	var I: integer;
	begin
	Result:=False;
	for I:=1 to Length(S) do
	 if not IsPrime(byte(S[I])) then exit;
	Result:=True;
	end;


begin
Cnt:=0;
S:='';
{Iterate all entries in dictionary}
for I:=0 to UnixDict.Count-1 do
 if IsPrimeWord(UnixDict[I]) then
	begin
	Inc(Cnt);
	Memo.Lines.Add(UnixDict[I]);
	end;
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;

