program uniqueCharacters(output);

type
	{ `integer…` prefix to facilitate sorting in documentation tools }
	integerNonNegative = 0..maxInt;
	{ all variables of this data type will be initialized to `1` }
	integerPositive = 1..maxInt value 1;
	
	charFrequency = array[char] of integerNonNegative;
	
	{ This “discriminates” the `string` _schema_ data type. }
	line = string(80);
	{ A schema data type definition looks sort of like a function: }
	lines(length: integerPositive) = array[1..length] of line;

{ `protected` in Extended Pascal means, you can’t modify this parameter. }
function createStatistics(protected sample: lines): charFrequency;
var
	i, n: integerPositive;
	{ The `value …` clause will initialize this variable to the given value. }
	statistics: charFrequency value [chr(0)..maxChar: 0];
begin
	{ You can inspect the discriminant of schema data type just like this: }
	for n := 1 to sample.length do
	begin
		{ The length of a `string(…)` though needs to be queried: }
		for i := 1 to length(sample[n]) do
		begin
			statistics[sample[n, i]] := statistics[sample[n, i]] + 1
		end
	end;
	
	{ There needs to be exactly one assignment to the result variable: }
	createStatistics := statistics
end;

{ === MAIN ============================================================= }
var
	c: char;
	sample: lines(3) value [1: '133252abcdeeffd';
		2: 'a6789798st'; 3: 'yxcdfgxcyz'];
	statistics: charFrequency;
begin
	statistics := createStatistics(sample);
	
	for c := chr(0) to maxChar do
	begin
		{
			The colon (`:`) specifies the display width of the parameter.
			While for `integer` and `real` values it means the _minimum_ width,
			for `string` and `char` values it is the _exact_ width.
		}
		write(c:ord(statistics[c] = 1))
	end;
	
	writeLn
end.
