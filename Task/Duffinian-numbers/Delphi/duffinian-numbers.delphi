{These subroutines would normally be in a library, but is included here for clarity}

function GetAllProperDivisors(N: Integer;var IA: TIntegerDynArray): integer;
{Make a list of all the "proper dividers" for N}
{Proper dividers are the of numbers the divide evenly into N}
var I: integer;
begin
SetLength(IA,0);
for I:=1 to N-1 do
 if (N mod I)=0 then
	begin
	SetLength(IA,Length(IA)+1);
	IA[High(IA)]:=I;
	end;
Result:=Length(IA);
end;


function GetAllDivisors(N: Integer;var IA: TIntegerDynArray): integer;
{Make a list of all the "proper dividers" for N, Plus N itself}
begin
Result:=GetAllProperDivisors(N,IA)+1;
SetLength(IA,Length(IA)+1);
IA[High(IA)]:=N;
end;



function IsDuffinianNumber(N: integer): boolean;
{Test number to see if it a Duffinian number}
var Facts1,Facts2: TIntegerDynArray;
var Sum,I,J: integer;
begin
Result:=False;
{Must be a composite number}
if IsPrime(N) then exit;
{Get all divisors}
GetAllDivisors(N,Facts1);
{Get sum of factors}
Sum:=0;
for I:=0 to High(Facts1) do
 Sum:=Sum+Facts1[I];
{Get all factor of Sum}
GetAllDivisors(Sum,Facts2);
{Test if the two number share any factors}
for I:=1 to High(Facts1) do
 for J:=1 to High(Facts2) do
	if Facts1[I]=Facts2[J] then exit;
{If not, they are relatively prime}
Result:=True;
end;

procedure ShowDuffinianNumbers(Memo: TMemo);
var N,Cnt,D1,D2,D3: integer;
var S: string;
begin
Cnt:=0;
S:='';
Memo.Lines.Add('First 50 Duffinian Numbers');
for N:=2 to high(integer) do
 if IsDuffinianNumber(N) then
	begin
	Inc(Cnt);
	S:=S+Format('%5d',[N]);
	if (Cnt mod 10)=0 then S:=S+CRLF;
	if Cnt>=50 then break;
	end;
Memo.Lines.Add(S);
D1:=0; D2:=-10; D3:=0;
S:=''; Cnt:=0;
Memo.Lines.Add('First 15 Duffinian Triples');
for N:=2 to high(integer) do
 if IsDuffinianNumber(N) then
	begin
	D1:=D2; D2:=D3;
	D3:=N;
	if ((D2-D1)=1) and ((D3-D2)=1) then
		begin
		Inc(Cnt);
		S:=S+Format('(%5d%5d%5d) ',[D1,D2,D3]);
		if (Cnt mod 3)=0 then S:=S+CRLF;
		if Cnt>=15 then break;
		end;
	end;
Memo.Lines.Add(S);
end;
