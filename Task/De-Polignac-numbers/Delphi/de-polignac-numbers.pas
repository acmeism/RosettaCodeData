function IsPrime(N: integer): boolean;
{Fast, optimised prime test}
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
           if ((N mod I) = 0) or ((N mod (I + 2)) = 0) then exit;
           Inc(I,6);
           end;
     Result:=True;
     end;
end;


function IsPolignac(N: integer): boolean;
{We are looking for 2^I + Prime = N
Therefore this 2^I - N should be prime}
var Pw2: integer;
begin
Result:=False;
Pw2:=1;
{Test all powers of less than N}
while Pw2<N do
	begin
	{If the difference is prime, it is not Polignac}
	if IsPrime(N-Pw2) then exit;
	Pw2:=Pw2 shl 1;
	end;
Result:=True;
end;


procedure ShowPolignacNumbers(Memo: TMemo);
{Show the first 50, 1000th and 10,000th Polignac numbers}
var I,Cnt: integer;
var S: string;
begin
Memo.Lines.Add('First 50 Polignac numbers:');
I:=1; Cnt:=0; S:='';
{Iterate through all odd numbers}
while true do
	begin
	if IsPolignac(I) then
		begin
		S:=S+Format('%10.0n',[I*1.0]);
		Inc(Cnt);
		if (Cnt mod 10)=0 then
			begin
			Memo.Lines.Add(S);
			S:='';
			end;

		end;
	Inc(I,2);
	if Cnt>=50 then break;
	end;
if S<>'' then Memo.Lines.Add(IntToStr(I));
while true do
	begin
	if IsPolignac(I) then
		begin
		Inc(Cnt);
		if Cnt=1000 then Memo.Lines.Add('1,000th = '+Format('%10.0n',[I*1.0]));
		if Cnt=10000 then
			begin
			Memo.Lines.Add('10,000th = '+Format('%10.0n',[I*1.0]));
			break;
			end;
		end;
	Inc(I,2);
	end;
end;


