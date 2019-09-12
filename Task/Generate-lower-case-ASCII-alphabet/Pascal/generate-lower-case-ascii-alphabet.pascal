program lowerCaseAscii(input, output, stdErr);
var
	alphabet: set of char;
begin
	// as per ISO 7185, 'a'..'z' do not necessarily have to be contiguous
	alphabet := [
			'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
			'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
		];
end.
