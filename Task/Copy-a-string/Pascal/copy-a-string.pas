program copyAString;
	var
		{ The Extended Pascal `string` schema data type
		  is essentially a `packed array[1..capacity] of char`. }
		source, destination: string(80);
	begin
		source := 'Hello world!';
		{ In Pascal _whole_ array data type values can be copied by assignment. }
		destination := source;
		{ Provided `source` is a _non-empty_ string value
		  you can copy in Extended Pascal sub-ranges _of_ _string_ types, too.
		  Note, the sub-range notation is not permitted for a `bindable` data type. }
		destination := source[1..length(source)];
		{ You can also employ Extended Pascal’s `writeStr` routine: }
		writeStr(destination, source);
	end.
