procedure ExponentDemo(Memo: TMemo);
begin
Memo.Lines.Add('5^3^2 =   '+FloatToStrF(Power(5,Power(3,2)),ffNumber,18,0));
Memo.Lines.Add('(5^3)^2 =    '+FloatToStrF(Power(Power(5,3),2),ffNumber,18,0));
Memo.Lines.Add('5^(3^2) = '+FloatToStrF(Power(5,Power(3,2)),ffNumber,18,0));
end;
