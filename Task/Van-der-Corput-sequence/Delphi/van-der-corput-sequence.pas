function VanDerCorput(N,Base: integer): double;
{Calculate binary value for numbers right of decimal}
var Value,Exponent,Digit: integer;
begin
Value:= N; Result:= 0; Exponent:= -1;
{D1 * Base^-1 + D2 * Base^-2 + D3 * Base^-3}
while Value > 0 do
	begin
	{Get digit in specified base}
	Digit:=Value mod Base;
	{Digit * Base^-Exponent}
	Result:=Result + Digit * Power(Base,Exponent);
	{Divide by base to put next digit in place}
	Value:= Value div Base;
	{Next exponent}
	Dec(Exponent);
	end;
end;


procedure ShowVanDerCorput(Memo: TMemo);
{Show Vander Coput numbers for bases 2..8 and items 1..9 }
var Base,N: integer;
var V: double;
var S: string;
begin
S:='';
for Base:=2 to 8 do
	begin
	S:=S+Format('Base %D:',[Base]);
	for N:=1 to 10 do
		begin
		V:=VanDerCorput(N,Base);
		S:=S+Format(' %1.5f',[V]);
		end;
	S:=S+CRLF;
	end;
Memo.Lines.Add(S);
end;
