program tauFunction(output);

type
	{ name starts with `integer…` to facilitate sorting in documentation }
	integerPositive = 1..maxInt value 1;
	{ the `value …` will initialize all variables to this value }

{ returns Boolean value of the expression divisor ∣ dividend ----------- }
function divides(
		protected divisor: integerPositive;
		protected dividend: integer
	): Boolean;
begin
	{ in Pascal, function result variable has the same name as function }
	divides := dividend mod divisor = 0
end;

{ returns τ(i) --------------------------------------------------------- }
function tau(protected i: integerPositive): integerPositive;
var
	count, potentialDivisor: integerPositive;
begin
	{ count is initialized to 1 and every number is divisible by one }
	for potentialDivisor := 2 to i do
	begin
		count := count + ord(divides(potentialDivisor, i))
	end;
	
	{ in Pascal, there must be exactly one assignment to result variable }
	tau := count
end;

{ === MAIN ============================================================= }
var
	i: integerPositive;
	f: string(6);
begin
	for i := 1 to 100 do
	begin
		writeStr(f, 'τ(', i:1);
		writeLn(f:8, ') = ', tau(i):5)
	end
end.
