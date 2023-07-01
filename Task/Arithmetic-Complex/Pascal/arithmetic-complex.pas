program complexDemo(output);

const
	{ I experienced some hiccups with -1.0 using GPC (GNU Pascal Compiler) }
	negativeOne = -1.0;

type
	line = string(80);

{ as per task requirements wrap arithmetic operations into separate functions }
function sum(protected x, y: complex): complex;
begin
	sum := x + y
end;

function product(protected x, y: complex): complex;
begin
	product := x * y
end;

function negative(protected x: complex): complex;
begin
	negative := -x
end;

function inverse(protected x: complex): complex;
begin
	inverse := x ** negativeOne
end;

{ only this function is not covered by Extended Pascal, ISO 10206 }
function conjugation(protected x: complex): complex;
begin
	conjugation := cmplx(re(x), im(x) * negativeOne)
end;

{ --- test suite ------------------------------------------------------------- }
function asString(protected x: complex): line;
const
	totalWidth = 5;
	fractionDigits = 2;
var
	result: line;
begin
	writeStr(result, '(', re(x):totalWidth:fractionDigits, ', ',
		im(x):totalWidth:fractionDigits, ')');
	asString := result
end;

{ === MAIN =================================================================== }
var
	x: complex;
	{ for demonstration purposes: how to initialize complex variables }
	y: complex value cmplx(1.0, 4.0);
	z: complex value polar(exp(1.0), 3.14159265358979);
begin
	x := cmplx(-3, 2);
	
	writeLn(asString(x), ' + ', asString(y), ' = ', asString(sum(x, y)));
	writeLn(asString(x), ' * ', asString(z), ' = ', asString(product(x, z)));
	
	writeLn;
	
	writeLn('               −', asString(z), '  = ', asString(negative(z)));
	writeLn('        inverse(', asString(z), ') = ', asString(inverse(z)));
	writeLn('    conjugation(', asString(y), ') = ', asString(conjugation(y)));
end.
