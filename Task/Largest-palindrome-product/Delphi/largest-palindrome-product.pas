type TProgress = procedure(Percent: integer);

function ReverseNum(N: int64): int64;
{Reverse the digit order of a number}
begin
Result:=0;
while N>0 do
	begin
	Result:=(Result*10)+(N mod 10);
	N:=N div 10;
	end;
end;


function IsPalindrome(N: int64): boolean;
{If the number is the same in }
{reverse order it is a palindrome}
var N1: int64;
begin
N1:=ReverseNum(N);
Result:=N = N1;
end;

procedure ShowPalindrome(Memo: TMemo; D,N1,N2: int64);
begin
Memo.Lines.Add(Format('%5D  %5D  %5D  %10D',[D,N1,N2,N1 * N2]));
end;


procedure FindPalindromes(Digits: integer; var C1,C2: int64; Prog: TProgress);
{Find the largest palindrome derrived from two}
{ terms with the specified number of digits}
var I,J: cardinal;
var Prd,MinNum,MaxNum,Best: int64;
begin
Best:=0;
{Find the minimum and maximum values}
{ with the specified number of digits}
MinNum:=Trunc(Power(10,Digits-1));
MaxNum:=Trunc(Power(10,Digits))-1;

for I:=MinNum to MaxNum do
	begin
	{We can eliminate even factors and number ending in 5}
	if ((I and 1)=0) or ((I mod 10)=5) then continue;
	for J:=I+1 to MaxNum do
		begin
		{We can eliminate even factors and number ending in 5}
		if ((J and 1)=0) or ((J mod 10)=5) then continue;
		Prd:=I * J;
		if not IsPalindrome(Prd) then continue;
		if Assigned(Prog) then Prog(MulDiv(100,I-MinNum,MaxNum-MinNum));
		{Save the largest palindromes}
		if Prd>Best then
			begin
			Best:=Prd;
			C1:=I; C2:=J;
			end;
		end;
	end;
end;


procedure FindPalindromeMax(Memo: TMemo; Prog: TProgress);
var N1,N2: Int64;
var I: integer;
begin
Memo.Lines.Add('Digits    F1     F2  Palindrome');
Memo.Lines.Add('-------------------------------');
for I:=2 to 4 do
	begin
	FindPalindromes(I,N1,N2,Prog);
	ShowPalindrome(Memo,I,N1,N2);
	end;
end;

