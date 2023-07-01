MODULE TestLen;

	IMPORT Out;

	PROCEDURE DoCharLength*;
		VAR s: ARRAY 16 OF CHAR; len: INTEGER;
	BEGIN
		s := "møøse";
		len := LEN(s$);
		Out.String("s: "); Out.String(s); Out.Ln;
		Out.String("Length of characters: "); Out.Int(len, 0); Out.Ln
	END DoCharLength;

END TestLen.
