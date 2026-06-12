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


var Facts: TIntegerDynArray;

function IsCalmoNumber(N: integer): boolean;
{Test number to see if it a Calmo number}
var Inx,Sum: integer;
begin
Result:=False;
{Get all divisors}
GetAllProperDivisors(N,Facts);
{strip off 1 }
Facts:=Copy(Facts,1,High(Facts));
if Length(Facts)<3 then exit;
{Must be at least three}
if (Length(Facts) mod 3)<>0 then exit;
Inx:=0;
repeat
	begin
	{Sum three factors}
	Sum:=Facts[Inx]+Facts[Inx+1]+Facts[Inx+2];
	{Exit if not primve}
	if not IsPrime(Sum) then exit;
	{Index to next three}
	Inc(Inx,3);
	end
until Inx>High(Facts)-1;
Result:=True;
end;


procedure ShowCalmoNumbers(Memo: TMemo);
{Show all Calmo numbers less than 1,000}
var I,J: integer;
var S: string;
begin
for I:=1 to 1000 do
 if IsCalmoNumber(I) then
	begin
	S:='';
	for J:=0 to High(Facts) do
	  S:=S+Format('%4d',[Facts[J]]);
	S:=Trim(S);
	Memo.Lines.Add(IntToStr(I)+'   ['+S+']');
	end;
end;



