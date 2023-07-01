function SumDigits(N: integer): integer;
{Sum the integers in a number}
var T: integer;
begin
Result:=0;
repeat
	begin
	T:=N mod 10;
	N:=N div 10;
	Result:=Result+T;
	end
until N<1;
end;


function IsNiven(N: integer): boolean;
{Test if N is evenly divisible by sum}
{i.e. is it a Niven Number}
var Sum: integer;
begin
Sum:=SumDigits(N);
Result:=(N mod Sum)=0;
end;


function GetNextNiven(Start: integer): integer;
{Get the next Niven number after Start}
begin
repeat Inc(Start)
until IsNiven(Start);
Result:=Start;
end;


procedure ShowNivenGaps(Memo: TMemo; Prog: TProgress);
{Show when gaps between sucessive Niven Numbers changes}
var I: integer;
var N1,N2,Gap: integer;
var Cnt: integer;
const Limit = 65000000;
begin
Memo.Lines.Add('  Gap   Gap          Niven          Niven           Next');
Memo.Lines.Add('Index Value          Index         Number   Niven Number');
Memo.Lines.Add('----- -----       --------      ---------   ------------');
Gap:=0; Cnt:=0;
N1:=GetNextNiven(0);
for I:=1 to Limit do
	begin
	{Get next Niven and test if Gap has changed}
	N2:=GetNextNiven(N1);
	if (N2-N1)>Gap then
		begin
		Gap:=N2-N1;
		Inc(Cnt);
		Memo.Lines.Add(Format('%5d%6d%15.0n%15.0n%15.0n',[Cnt,Gap,I+0.0,N1+0.0,N2+0.0]));
		end;
	N1:=N2;
	if Assigned(Prog) and ((I mod 100000)=0) then Prog(MulDiv(100,I,Limit));
	end;
end;
