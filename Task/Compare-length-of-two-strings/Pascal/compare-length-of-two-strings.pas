program compareLengthOfStrings(output);

const
	specimenA = 'RosettaCode';
	specimenB = 'Pascal';
	specimenC = 'Foobar';
	specimenD = 'Pascalish';

type
	specimen = (A, B, C, D);
	specimens = set of specimen value [];

const
	specimenMinimum = A;
	specimenMaximum = D;

var
	{ the explicit range min..max serves as a safeguard to update max const }
	list: array[specimenMinimum..specimenMaximum] of string(24)
		value [A: specimenA; B: specimenB; C: specimenC; D: specimenD];
	lengthRelationship: array[specimen] of specimens;

procedure analyzeLengths;
var
	left, right: specimen;
begin
	for left := specimenMinimum to specimenMaximum do
	begin
		for right := specimenMinimum to specimenMaximum do
		begin
			if length(list[left]) < length(list[right]) then
			begin
				lengthRelationship[right] := lengthRelationship[right] + [right]
			end
		end
	end
end;

procedure printSortedByLengths;
var
	i: ord(specimenMinimum)..ord(specimenMaximum);
	s: specimen;
begin
	{ first the string longer than all other strings }
	{ lastly print the string not longer than any other string }
	for i := ord(specimenMaximum) downto ord(specimenMinimum) do
	begin
		{ for demonstration purposes: iterate over a set }
		for s in [specimenMinimum..specimenMaximum] do
		begin
			{ card returns the cardinality ("population count") }
			if card(lengthRelationship[s]) = i then
			begin
				writeLn(length(list[s]):8, ' ', list[s])
			end
		end
	end
end;

begin
	analyzeLengths;
	printSortedByLengths
end.
