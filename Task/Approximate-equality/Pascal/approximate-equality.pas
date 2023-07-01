program approximateEqual(output);

{
	\brief determines whether two `real` values are approximately equal
	\param x a reference value
	\param y the value to compare with \param x
	\return true if \param x is equal or approximately equal to \param y
}
function equal(protected x, y: real): Boolean;
	function approximate: Boolean;
		function d(protected x: real): integer;
		begin
			d := trunc(ln(abs(x) + minReal) / ln(2)) + 1
		end;
	begin
		approximate := abs(x - y) <= epsReal * (maxReal / (d(x) + d(y)))
	end;
begin
	equal := (x = y) or_else (x * y >= 0.0) and_then approximate
end;

{ --- auxilliary routines ---------------------------------------------- }
procedure test(protected x, y: real);
const
	{ ANSI escape code for color coding }
	CSI = chr(8#33) + '[';
	totalMinimumWidth = 40;
	postRadixDigits = 24;
begin
	write(x:totalMinimumWidth:postRadixDigits, '':1, CSI, '1;3');
	
	if equal(x, y) then
	begin
		if x = y then
		begin
			write('2m≅')
		end
		else
		begin
			write('5m≆')
		end
	end
	else
	begin
		write('1m≇')
	end;
	
	writeLn(CSI, 'm', '':1, y:totalMinimumWidth:postRadixDigits)
end;

{ === MAIN ============================================================= }
var
	n: integer;
	x: real;
begin
	{ Variables were used to thwart compile-time evaluation done }
	{ by /some/ compilers potentially confounding the results. }
	n := 2;
	x := 100000000000000.01;
	
	test(x, 100000000000000.011);
	test(100.01, 100.011);
	test(x / 10000.0, 1000000000.0000001000);
	test(0.001, 0.0010000001);
	test(0.000000000000000000000101, 0.0);
	x := sqrt(n);
	test(sqr(x), 2.0);
	test((-x) * x, -2.0);
	test(3.14159265358979323846, 3.14159265358979324)
end.
