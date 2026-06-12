program sortTheLettersOfStringInAlphabeticalOrder(input, output);

type
	line = string(80);

{
	sort characters in a string
	
	\param sample the string to sort
	\return \param sample so for all n < m: sample[n] <= sample[m]
}
function alphabeticallySorted(sample: line): line;
var
	c: char;
	{ `sample.capacity` refers to 80 in this program. }
	i: 0..sample.capacity;
	{ `… value [otherwise 0]` is an initial state specification. }
	tab: array[char] of 0..sample.capacity value [otherwise 0];
begin
	{ analyze: how many occurrences of every character? }
	for i := 1 to length(sample) do
	begin
		tab[sample[i]] := tab[sample[i]] + 1
	end;
	
	{ process: rebuild string but in alphabetical order }
	sample := '';
	
	for c := chr(0) to maxChar do
	begin
		for i := 1 to tab[c] do
		begin
			sample := sample + c
		end
	end;
	
	{ finish: set result variable }
	alphabeticallySorted := sample
end;

{ === MAIN =================================================== }
var
	s: line;
begin
	while not EOF do
	begin
		readLn(s);
		writeLn(alphabeticallySorted(s))
	end
end.
