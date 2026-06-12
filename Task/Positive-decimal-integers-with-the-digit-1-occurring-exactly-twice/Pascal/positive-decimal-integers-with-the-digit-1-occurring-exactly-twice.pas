program positiveDecimalIntegersWithTheDigit1occurringExactlyTwice(output);
var
	n: integer;
begin
	for n := 1 to 999 do
	begin
		if ord(n mod 10 = 1) + ord(n mod 100 div 10 = 1) + ord(n div 100 = 1) = 2 then
		begin
			writeLn(n)
		end
	end
end.
