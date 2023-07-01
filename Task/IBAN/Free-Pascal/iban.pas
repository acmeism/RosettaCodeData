{$mode objFPC}

uses
	// for delSpace function
	strUtils,
	// GNU multiple-precision library
	GMP;

var
	/// this trie contains the correct IBAN length depending on the country code
	IBANLengthInCountry: array['A'..'Z', 'A'..'Z'] of integer;

type
	/// Human-readable representation of an IBAN without spaces
	IBANRepresentation = string[34];

{
	determines whether an IBANRepresentation is technically potentially correct
	
	\param sample the human-readable IBAN representation
	\return \param sample constains less than the most detectable errors
}
function isLegal(sample: IBANRepresentation): Boolean;
	function checksumCorrect(sample: IBANRepresentation): Boolean;
		type
			digitSequence = string[68];
		function convertLetters(const sequence: IBANRepresentation): digitSequence;
		var
			i: integer;
			transliteration: string[2];
		begin
			// initialize length to zero
			result := '';
			
			for i := 1 to length(sequence) do
			begin
				// by default assume it is a Western-Arabic digit
				transliteration := sequence[i];
				
				// otherwise we’ll need to transliterate the Latin alphabet character
				if not (sequence[i] in ['0'..'9']) then
				begin
					writeStr(transliteration, ord(sequence[i]) - ord('A') + 10);
				end;
				
				// appending transliteration to result also changes the length field
				result := result + transliteration;
			end;
		end;
		var
			i, k: MPInteger;
		begin
			k := 97;
			
			// put first four characters toward end
			writeStr(sample, sample[5..length(sample)], sample[1..4]);
			// interpret converted string as integer to base 10
			Z_set_str(i, convertLetters(sample), 10);
			
			i := Z_mod(i, k);
			k := 1;
			checksumCorrect := Z_cmp(i, k) = 0;
		end;
	begin
		sample := upCase(sample);
		{$push}
			// just for emphasis: by default the FPC performs lazy evaluation
			{$boolEval off}
			isLegal := (length(sample) = IBANLengthInCountry[sample[1], sample[2]])
				and checksumCorrect(sample);
		{$pop}
	end;

// === MAIN ==============================================================
begin
	// for the sake of merely achieving the Rosetta Code Task
	IBANLengthInCountry['G', 'B'] := 22;
	
	// note, strings longer than 34 characters will be silently clipped
	writeLn(isLegal(delSpace('GB82 WEST 1234 5698 7654 32')));
end.
