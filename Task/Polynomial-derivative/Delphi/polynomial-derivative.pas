const Poly1: array [0..1-1] of double = (5);		{5}
const Poly2: array [0..2-1] of double = (4,-3);		{-3x+4}
const Poly3: array [0..3-1] of double = (-1,6,5);	{5x^2+6x-1}
const Poly4: array [0..4-1] of double = (-4,3,-2,1);	{x^3-2x^2+3x-4}
const Poly5: array [0..5-1] of double = (1,1,0,-1,-1);	{-x^4-x^3+x+1}



function GetDerivative(P: array of double): TDoubleDynArray;
var I,N: integer;
begin
SetLength(Result,Length(P)-1);
if Length(P)<1 then exit;
for I:=0 to High(Result) do
Result[I]:= (I+1)*P[I+1];
end;


function GetPolyStr(D: array of double): string;
{Get polynomial in standard math format string}
var I: integer;
var S: string;

	function GetSignStr(Lead: boolean; D: double): string;
	{Get the sign of coefficient}
	begin
	Result:='';
	if D>0 then
		begin
		if not Lead then Result:=' + ';
	 	end
	else
		begin
		Result:='-';
		if not Lead then Result:=' - ';
		end;
	end;


begin
Result:='';
{Get each coefficient}
for I:=High(D) downto 0 do
	begin
	{Ignore zero values}
	if D[I]=0 then continue;
	{Get sign and coefficient}
	S:=GetSignStr(Result='',D[I]);
	S:=S+FloatToStrF(abs(D[I]),ffFixed,18,0);
	{Combine with exponents }
	if I>1 then Result:=Result+Format('%SX^%d',[S,I])
	else if I=1 then Result:=Result+Format('%SX',[S,I])
	else Result:=Result+Format('%S',[S]);
	end;
end;

procedure ShowDerivative(Memo: TMemo; Poly: array of double);
{Show polynomial and and derivative}
var D: TDoubleDynArray;
begin
D:=GetDerivative(Poly);
Memo.Lines.Add('Polynomial: '+GetPolyStr(Poly));
Memo.Lines.Add('Derivative: '+'['+GetPolyStr(D)+']');
Memo.Lines.Add('');
end;



procedure ShowPolyDerivative(Memo: TMemo);
var D: TDoubleDynArray;
begin
ShowDerivative(Memo,Poly1);
ShowDerivative(Memo,Poly2);
ShowDerivative(Memo,Poly3);
ShowDerivative(Memo,Poly4);
ShowDerivative(Memo,Poly5);
end;
