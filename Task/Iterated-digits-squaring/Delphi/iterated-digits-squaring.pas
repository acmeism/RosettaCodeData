function SumSquaredDigits(N: integer): integer;
{Sum the squares of the digits in a number}
var T: integer;
begin
Result:=0;
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	Result:=Result+T*T;
	end
until N<1;
end;


function TestNumber(N: integer): integer;
{Sum the squares of the digits of number, and do it again}
{with tne new number until the result is either 89 or 1}
begin
Result:=N;
repeat Result:=SumSquaredDigits(Result);
until (Result=89) or (Result=1);
end;


procedure TestSquareDigitsSum(Memo: TMemo);
{Count the number of square digit sums end up 89}
var I,Cnt: integer;
begin
Cnt:=0;
for I:=1 to 100000000 do
 if TestNumber(I)=89 then Inc(Cnt);
Memo.Lines.Add(IntToStr(Cnt));
end;
