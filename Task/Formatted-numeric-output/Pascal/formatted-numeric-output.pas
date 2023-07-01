procedure writeInFixedFormat(n: real);
const
	wholeNumberPlaces = 5;
	fractionalPlaces = 3;
	zeroDigit = '0';
	negative = '-';
var
	signPresent: boolean;
	i: integer;
begin
	// NOTE: This does not catch “negative” zero.
	signPresent := n < 0.0;
	if signPresent then
	begin
		write(negative);
		n := abs(n);
	end;
	
	// determine number of leading zeros
	i := wholeNumberPlaces;
	if n > 0 then
	begin
		i := i - trunc(ln(n) / ln(10));
	end;
	
	for i := i - 1 downto succ(ord(signPresent)) do
	begin
		write(zeroDigit);
	end;
	
	// writes n with
	// - at least 0 characters in total
	// - exactly fractionalPlaces post-radix digits
	// rounded
	write(n:0:fractionalPlaces);
end;
