// in FPC 3.2.0 the definition of `integer` still depends on the compiler mode
{$mode objFPC}

uses
	// used for `isInfinite`, `isNan` and `fMod`
	math,
	// NB: `ucomplex`’s `complex` isn’t a simple data type as ISO 10206 requires
	ucomplex;

{ --- determines whether a `float` value is (almost) an `integer` ------ }
function isInteger(x: float; const fuzziness: float = 0.0): Boolean;
	// nested routine allows us to spare an `if … then` statement below
	function fuzzyInteger: Boolean;
	begin
		// `x mod 1.0` uses `fMod` function from `math` unit
		x := x mod 1.0;
		result := (x <= fuzziness) or (x >= 1.0 - fuzziness);
	end;
begin
	{$push}
		// just for emphasis: use lazy evaluation strategy (currently default)
		{$boolEval off}
		result := not isInfinite(x) and not isNan(x) and fuzzyInteger;
	{$pop}
end;

{ --- check whether a `complex` number is (almost) in ℤ ---------------- }
function isInteger(const x: complex; const fuzziness: float = 0.0): Boolean;
begin
	// you could use `isZero` from the `math` unit for a fuzzy zero
	isInteger := (x.im = 0.0) and isInteger(x.re, fuzziness)
end;

{ --- test routine ----------------------------------------------------- }
procedure test(const x: float);
const
	tolerance = 0.00001;
	w = 42;
var
	s: string;
begin
	writeStr(s, 'isInteger(', x);
	writeLn(s:w, ') = ', isInteger(x):5,
		s:w, ', ', tolerance:7:5, ') = ', isInteger(x, tolerance):5);
end;

{ === MAIN ============================================================= }
begin
	test(25.000000);
	test(24.999999);
	test(25.000100);
	test(-2.1e120);
	test(-5e-2);
	test(NaN);
	test(Infinity);
	writeLn(isInteger(5.0 + 0.0 * i));
	writeLn(isInteger(5 - 5 * i));
end.
