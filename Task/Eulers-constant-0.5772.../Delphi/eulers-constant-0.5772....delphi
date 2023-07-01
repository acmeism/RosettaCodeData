function ComputeEuler(N: int64): double;
{Compute Eurler number with N-number of iterations}
var I: integer;
var A: double;
begin
Result:=0;
for I:=1 to N-1 do
  Result:=Result + 1 / I;
A:=Ln(N + 0.5 + 1/(24.0*N));
Result:=Result-A;
end;



procedure ShowEulersNumber(Memo: TMemo);
{Show Euler numbers at various levels of precision}
var Euler,G,A,Error: double;
var N: integer;
const Correct =0.57721566490153286060651209008240243104215933593992;

	procedure ShowEulerError(N: int64);
	{Show Euler number and Error}
	begin
	Euler:=ComputeEuler(N);
	Error:=Correct-Euler;
	Memo.Lines.Add('N =   '+FloatToStrF(N,ffNumber,18,0));
	Memo.Lines.Add('Euler='+FloatToStrF(Euler,ffFixed,18,18));
	Memo.Lines.Add('Error='+FloatToStrF(Error,ffFixed,18,18));
	Memo.Lines.Add('');
	end;

begin
{Compute Euler number with iterations ranging 10 to 10^9}
for N:=1 to 9 do
	begin
	ShowEulerError(Trunc(Power(10,N)));
	end;

end;
