program removeVowelsFromString(input, output);
const
	vowels = ['A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'];
var
	i: integer;
	{ Extended Pascal: `… value ''` initializes both variables with `''`. }
	line, disemvoweledLine: string(80) value '';

begin
	readLn(line);
	
	for i := 1 to length(line) do
	begin
		if not (line[i] in vowels) then
		begin
			disemvoweledLine := disemvoweledLine + line[i]
		end
	end;
	
	writeLn(disemvoweledLine)
end.
