program luhnTestOfCreditCardNumbers(input, output);

type
	{
		`string(…)` is an Extended Pascal, ISO 10206, extension.
		`string(64)` discriminates the “schema” data type `string`
		to contain at most 64 `char` values.
	}
	creditCardNumber = string(64);

{
	\brief determines whether a string contains digits only
	
	\param sample the string to inspect
	\return `false` iff `sample` contains non-digit characters
}
{ Extended Pascal: `protected` means the function cannot modify `sample` }
function containsDigitsOnly(protected sample: creditCardNumber): Boolean;
var
	{ EP: the `… value []` initializes this variable as an empty set }
	characters: set of char value [];
	{ `sample.capacity` refers to `64` in this code. }
	i: 1..sample.capacity;
begin
	for i := 1 to length(sample) do
	begin
		{ Union of sets indicated by `+`. }
		characters := characters + [sample[i]]
	end;
	
	{
		In a Pascal `function` definition,
		there must be one assignment to the (implicit) variable
		bearing the same name as of the function.
		This will be the return value.
	}
	{ NB: This will return `true` even if `length(sample)` is zero. }
	containsDigitsOnly := card(characters - ['0'..'9']) = 0
	{ `card` is an Extended Pascal extension. }
end;

{
	\brief determines whether a string complies with ISO/IEC 7812-1 Luhn test
	
	\param sample the potentially correct credit card number
	\return `true` if verification succeeds
}
function luhnCheck(protected sample: creditCardNumber): Boolean;
	{
		This _nested_ function is only accessible _within_ `luhnCheck`.
		Outsourcing this code allows us to write a neat expression below.
	}
	function check: Boolean;
	var
		{ Using `integer` sub-ranges ensures only these values are assigned. }
		sum: 0..maxInt value 0;
		i: 0..sample.capacity-1;
	begin
		for i := 0 to length(sample) - 1 do
		begin
			{ `1 + ord(odd(i))` produces an alternating scale factor `* 1`/`* 2`. }
			sum := sum + (1 + ord(odd(i))) *
				{ Obtain digit value for `integer` calculation. }
				(ord(sample[length(sample) - i]) - ord('0')) -
				{ Reverse operation if digit sum > 9, i.e. we added “too much”. }
				ord(odd(i) and (sample[length(sample) - i] >= '5')) * 9
		end;
		
		check := sum mod 10 = 0
	end;
begin
	{
		The Extended Pascal Boolean operator `and_then` (and `or_else`)
		allows for “short-circuit evaluation”.
		Otherwise, in Pascal `and` and `or` mandate complete evaluation.
	}
	luhnCheck := (length(sample) > 0) and_then containsDigitsOnly(sample)
		and_then check
end;

{ === MAIN ============================================================= }
var
	s: creditCardNumber;
begin
	{ `EOF` is short for `EOF(input)`. }
	while not EOF do
	begin
		readLn(s); { equivalent to `readLn(input, s)` }
		writeLn(luhnCheck(s)) { = `writeLn(output, …)` }
	end
end.
