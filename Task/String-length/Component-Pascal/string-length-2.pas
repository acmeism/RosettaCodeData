MODULE TestLen;

	IMPORT Out;

	PROCEDURE DoByteLength*;
		VAR s: ARRAY 16 OF CHAR; len, v: INTEGER;
	BEGIN
		s := "møøse";
		len := LEN(s$);
		v := SIZE(CHAR) * len;
		Out.String("s: "); Out.String(s); Out.Ln;
		Out.String("Length of characters in bytes: "); Out.Int(v, 0); Out.Ln
	END DoByteLength;

END TestLen.
