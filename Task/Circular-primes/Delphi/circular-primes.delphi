procedure ShowCircularPrimes(Memo: TMemo);
{Show list of the first 19, cicular primes}
var I,Cnt: integer;
var S: string;



	procedure RotateStr(var S: string);
	{Rotate characters in string}
	var I: integer;
	var C: char;
	begin
	C:=S[Length(S)];
	for I:=Length(S)-1 downto 1 do S[I+1]:=S[I];
	S[1]:=C;
	end;


	function IsCircularPrime(N: integer): boolean;
	{Test if all rotations of number are prime and}
	{A rotation of the number hasn't been used before}
	var I,P: integer;
	var NS: string;
	begin
	Result:=False;
	NS:=IntToStr(N);
	for I:=1 to Length(NS)-1 do
		begin
		{Rotate string and convert to integer}
		RotateStr(NS);
		P:=StrToInt(NS);
		{Exit if number is not prime or}
		{Is prime, is less than N i.e. we've seen it before}
		if not IsPrime(P) or (P<N) then exit;
		end;
	Result:=True;
	end;

begin
S:='';
Cnt:=0;
{Look for circular primes and display 1st 19}
for I:=0 to High(I) do
 if IsPrime(I) then
 if IsCircularPrime(I) then
 	begin
	Inc(Cnt);
	S:=S+Format('%7D',[I]);
	if Cnt>=19 then break;
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
end;
