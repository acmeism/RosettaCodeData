program exponentiationWithInfixOperatorsInTheBase(output);

const
	minimumWidth = 7;
	fractionDigits = minimumWidth div 4 + 1;

procedure testIntegerPower(
		{ `pow` can in fact accept `integer`, `real` and `complex`. }
		protected base: integer;
		{ For `pow` the `exponent` _has_ to be an `integer`. }
		protected exponent: integer
	);
begin
	writeLn('=====> testIntegerPower <=====');
	writeLn('                base = ', base:minimumWidth);
	writeLn('            exponent = ', exponent:minimumWidth);
	{ Note: `exponent` may not be negative if `base` is zero! }
	writeLn('  -base pow exponent = ', -base pow exponent:minimumWidth);
	writeLn('-(base) pow exponent = ', -(base) pow exponent:minimumWidth);
	writeLn('(-base) pow exponent = ', (-base) pow exponent:minimumWidth);
	writeLn('-(base pow exponent) = ', -(base pow exponent):minimumWidth)
end;

procedure testRealPower(
		{ `**` actually accepts all data types (`integer`, `real`, `complex`). }
		protected base: real;
		{ The `exponent` in an `**` expression will be, if applicable, }
		{ _promoted_ to a `real` value approximation. }
		protected exponent: integer
	);
begin
	writeLn('======> testRealPower <======');
	writeLn('               base = ', base:minimumWidth:fractionDigits);
	writeLn('           exponent = ', exponent:pred(minimumWidth, succ(fractionDigits)));
	if base > 0.0 then
	begin
		{ The result of `base ** exponent` is a `complex` value }
		{ `base` is a `complex` value, `real` otherwise. }
		writeLn('  -base ** exponent = ', -base ** exponent:minimumWidth:fractionDigits);
		writeLn('-(base) ** exponent = ', -(base) ** exponent:minimumWidth:fractionDigits);
		writeLn('(-base) ** exponent = illegal');
		writeLn('-(base ** exponent) = ', -(base ** exponent):minimumWidth:fractionDigits)
	end
	else
	begin
		{ “negative” zero will not alter the sign of the value. }
		writeLn('  -base ** exponent = ', -base pow exponent:minimumWidth:fractionDigits);
		writeLn('-(base) ** exponent = ', -(base) pow exponent:minimumWidth:fractionDigits);
		writeLn('(-base) ** exponent = ', (-base) pow exponent:minimumWidth:fractionDigits);
		writeLn('-(base ** exponent) = ', -(base pow exponent):minimumWidth:fractionDigits)
	end
end;

{ === MAIN =================================================================== }
begin
	testIntegerPower(-5, 2);
	testIntegerPower(+5, 2);
	testIntegerPower(-5, 3);
	testIntegerPower( 5, 3);
	testRealPower(-5.0, 2);
	testRealPower(+5.0, 2);
	testRealPower(-5E0, 3);
	testRealPower(+5E0, 3)
end.
