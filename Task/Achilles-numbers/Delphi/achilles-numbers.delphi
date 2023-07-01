function GetTotient(N: integer): integer;
{Calculate Euler's Totient}
var M: integer;
begin
Result:= 0;
for M:= 1 to N do
 if GreatestCommonDivisor(M, N) = 1 then
    Result:= Result+1;
end;


function IsPowerfulNum(N: integer): boolean;
{Is a powerful number i.e. all prime factors square are divisor}
var I: integer;
var IA: TIntegerDynArray;
begin
Result:=False;
GetPrimeFactors(N,IA);
for I:=0 to High(IA) do
 if (N mod (IA[I]*IA[I]))<>0 then exit;
Result:=True;
end;


function CanBeMtoK(N: integer): boolean;
{Can N be represented as M^K?}
var M, A: integer;
begin
Result:=False;
M:= 2;
A:= M*M;
repeat
	begin
	while true do
		begin
		if A = N then exit;
                if A > N then break;
                A:= A*M;
                end;
        M:= M+1;
        A:= M*M;
        end
until   A > N;
Result:=True;
end;


function IsAchilles(N: integer): boolean;
{Achilles = Is Powerful and can be M^K}
begin
Result:=IsPowerfulNum(N) and CanBeMtoK(N);
end;



procedure AchillesNumbers(Memo: TMemo);
var I,Cnt,Digits: integer;
var S: string;
var DigCnt: array [0..5] of integer;
begin
Memo.Lines.Add('First 50 Achilles numbers:');
Cnt:=0; S:='';
for I:=2 to high(Integer) do
 if IsAchilles(I) then
	begin
	Inc(Cnt);
	S:=S+Format('%6d',[I]);
	if (Cnt mod 10)=0 then S:=S+CRLF;
	if Cnt>=50 then break;
	end;
Memo.Lines.Add(S);

Memo.Lines.Add('First 20 Strong Achilles Numbers:');
Cnt:=0; S:='';
for I:=2 to high(Integer) do
 if IsAchilles(I) then
   if IsAchilles(GetTotient(I)) then
	begin
	Inc(Cnt);
	S:=S+Format('%6d',[I]);
	if (Cnt mod 10)=0 then S:=S+CRLF;
	if Cnt>=20 then break;
	end;
Memo.Lines.Add(S);

Memo.Lines.Add('Digits Counts:');
for I:=0 to High(DigCnt) do DigCnt[I]:=0;
for I:=2 to high(Integer) do
	begin
	Digits:=NumberOfDigits(I);
	if Digits>High(DigCnt) then break;
	if IsAchilles(I) then Inc(DigCnt[Digits]);
	end;
Memo.Lines.Add('Last Count: '+IntToStr(I));
for I:=0 to High(DigCnt) do
 if DigCnt[I]>0 then
	begin
	Memo.Lines.Add(Format('%d digits: %d',[I,DigCnt[I]]));
	end
end;
