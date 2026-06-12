program sumOfFirstNCubes(output);
const
	N = 49;
var
	i: integer;
	sum: integer;
begin
	sum := 0;
	for i := 0 to N do
	begin
		sum := sum + sqr(i) * i;
		{ In Extended Pascal you could also write:
		sum := sum + i pow 3; }
		writeLn(sum)
	end
end.
