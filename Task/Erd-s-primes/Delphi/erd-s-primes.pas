function IsPrime(N: integer): boolean;
{Optimised prime test - about 40% faster than the naive approach}
var I,Stop: integer;
begin
if (N = 2) or (N=3) then Result:=true
else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result:= false
else
	begin
	I:=5;
	Stop:=Trunc(sqrt(N));
	Result:=False;
	while I<=Stop do
		begin
		if ((N mod I) = 0) or ((N mod (i + 2)) = 0) then exit;
		Inc(I,6);
		end;
	Result:=True;
	end;
end;



function Factorial(N: Word): int64;
var  I: integer;
begin
Result:= 1;
for I := 2 to N do Result:=Result * I;
end;


function IsErdosPrime(P: integer): boolean;
{Test if specified Primes is Erdos}
{i.e. all p-k! for 1<=k!<p are composite.}
var K: integer;
var F: int64;
begin
K:=1;
Result:=False;
while True do
	begin
	F:=Factorial(K);
	if F>=P then break;
	if IsPrime(P-F) then exit;
	Inc(K);
	end;
Result:=True;
end;


procedure FindErdosPrimes(Memo: TMemo);
{Collect and display Erdos primes}
var P,I,Cnt: integer;
var Erdos: array of integer;
var S: string;
begin
{Collect all Erdos Primes<1,000,000}
for P:=2 to 1000000 do
 if IsPrime(P) then
  if IsErdosPrime(P) then
	begin
	SetLength(Erdos,Length(Erdos)+1);
	Erdos[High(Erdos)]:=P;
	end;
{Display the data in several different ways}
Memo.Lines.Add('25 Erdos primes less than 2500');
S:='';
for I:=0 to 24 do
	begin
	S:=S+Format('%8d',[Erdos[I]]);
	if (((I+1) mod 5)=0) or (I=24) then
		begin
		Memo.Lines.Add(S);
		S:='';
		end;
	end;
Memo.Lines.Add('Summary:');
Memo.Lines.Add('Number of Erdos Primes < 1-million: '+IntToStr(Length(Erdos)));
Memo.Lines.Add('Last Erdos Prime < 1-million: '+IntToStr(Erdos[High(Erdos)]));
end;


