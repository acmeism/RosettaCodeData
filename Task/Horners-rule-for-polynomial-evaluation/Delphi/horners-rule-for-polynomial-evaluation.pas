function EvaluatePolynomial(Args: array of double; X: double): double;
{Evaluate polynomial using Horner's rule }
var I: integer;
begin
Result:=0;
for I:=High(Args) downto 0 do
    Result:=(Result * X ) + Args[I];
end;

function GetPolynomialStr(Args: array of double; VarName: string): string;
{Return a string display the polynomial in normal format}
{for example: 6.0 X^3 - 4.0 X^2 + 7.0 X - 19.0}
var I: integer;
begin
Result:='';
for I:=High(Args) downto 0 do
	begin
	if Args[I]>0 then
		begin
		if I<>High(Args) then Result:=Result+' + ';
		end
	else Result:=Result+' - ';
	Result:=Result+FloatToStrF(Abs(Args[I]),ffFixed,18,1);
	if I>0 then Result:=Result+' '+VarName;
	if I>1 then Result:=Result+'^'+IntToStr(I);
	end;
end;


procedure ShowHornerPoly(Memo: TMemo; Args: array of double; X: double);
{Evaluate polynomial, show formated polynomal and the result}
var R: double;
begin
R:=EvaluatePolynomial(Args,X);
Memo.Lines.Add(FloatToStrF(R,ffFixed, 18,1));
Memo.Lines.Add(GetPolynomialStr(Args,'X'));
end;


procedure DoHornerPoly(Memo: TMemo);
begin
ShowHornerPoly(Memo,[-19, 7, -4, 6],3)
end;
