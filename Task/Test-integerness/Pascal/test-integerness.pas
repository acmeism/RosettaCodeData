program integerness(output);

{ determines whether a `complex` also fits in `integer` ---------------- }
function isRealIntegral(protected x: complex): Boolean;
begin
	{ It constitutes an error if no value for `trunc(x)` exists, }
	{ thus check re(x) is in the range -maxInt..maxInt first. }
	isRealIntegral := (im(x) = 0.0) and_then
		(abs(re(x)) <= maxInt * 1.0) and_then
		(trunc(re(x)) * 1.0 = re(x))
end;

{ calls isRealIntegral with zero imaginary part ------------------------ }
function isIntegral(protected x: real): Boolean;
begin
	isIntegral := isRealIntegral(cmplx(x * 1.0, 0.0))
end;

{ Rosetta code test ---------------------------------------------------- }
procedure test(protected x: complex);
begin
	writeLn(re(x), ' + ', im(x), ' 𝒾 : ',
		isIntegral(re(x)), ' ', isRealIntegral(x))
end;
	
{ === MAIN ============================================================= }
begin
	test(cmplx(25.0, 0.0));
	test(cmplx(24.999999, 0.0));
	test(cmplx(25.000100, 0.0));
	test(cmplx(-2.1E120, 0.0));
	test(cmplx(-5E-2, 0.0));
	test(cmplx(5.0, 0.0));
	test(cmplx(5, -5));
end.
