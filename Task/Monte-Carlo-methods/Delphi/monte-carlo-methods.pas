function MonteCarloPi(N: cardinal): double;
{Approximate Pi by seeing if points fall inside circle}
var I,InsideCnt: integer;
var X,Y: double;
begin
InsideCnt:=0;
for I:=1 to N do
	begin
	{Random X,Y = 0..1}
	X:=Random;
	Y:=Random;
	{See if it falls in Unit Circle}
	if X*X + Y*Y <= 1 then Inc(InsideCnt);
	end;
{Because X and Y are squared, they only fall with 1/4 of the circle}
Result:=4 * InsideCnt / N;
end;


procedure ShowOneSimulation(Memo: TMemo; N: cardinal);
var MyPi: double;
begin
MyPi:=MonteCarloPi(N);
Memo.Lines.Add(Format('Samples: %15.0n   Pi= %2.15f',[N+0.0,MyPi]));
end;


procedure ShowMonteCarloPi(Memo: TMemo);
begin
ShowOneSimulation(Memo,1000);
ShowOneSimulation(Memo,10000);
ShowOneSimulation(Memo,100000);
ShowOneSimulation(Memo,1000000);
ShowOneSimulation(Memo,10000000);
ShowOneSimulation(Memo,100000000);
end;
