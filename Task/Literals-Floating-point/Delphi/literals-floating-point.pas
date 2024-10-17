procedure FloatLiterals(Memo: TMemo);
{Delphi has multiple floating number formats}
var R48: Real48;	{48-bit real number}
var SI: Single;		{32-bit real number}
var D: Double;		{64-bit real number}
var E: Extended;	{80-bit real number}
var Cmp: Comp;		{}
var Cur: Currency;	{Fixed point number for currency}
begin
{Various formats that can be used on input or
as constants assigned to various reals.
Pascal automaically converts integer to
reals as long as the real has enough precision
to hold the value. Consequently, all of the
following constants can be assigned to a real.}
D:=1234;
D:=1.234;
D:=1234E-4;
D:=$7F;
{Reals can also be output in various formats.}
D:=123456789.1234;
Memo.Lines.Add(FloatToStrF(D,ffGeneral,18,4));
Memo.Lines.Add(FloatToStrF(D,ffExponent,18,4));
Memo.Lines.Add(FloatToStrF(D,ffFixed,18,4));
Memo.Lines.Add(FloatToStrF(D,ffNumber,18,4));
Memo.Lines.Add(FloatToStrF(D,ffCurrency,18,4));
Memo.Lines.Add(Format('%10.4f',[D]));
end;
