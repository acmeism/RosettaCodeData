PROGRAM entropytest;

USES StrUtils, Math;

TYPE FArray = ARRAY of CARDINAL;

VAR	 strng: STRING = '1223334444';
	
// list unique characters in a string
FUNCTION uniquechars(str: STRING): STRING;
	VAR n: CARDINAL;
	BEGIN
		uniquechars := '';
		FOR n := 1 TO length(str) DO
			IF (PosEx(str[n],str,n)>0)
				AND (PosEx(str[n],uniquechars,1)=0)
					THEN uniquechars += str[n];
	END;
	
// obtain a list of character-frequencies for a string
//  given a string containing its unique characters
FUNCTION frequencies(str,ustr: STRING): FArray;
	VAR u,s,p,o: CARDINAL;
	BEGIN
		SetLength(frequencies, Length(ustr)+1);
		p := 0;
		FOR u := 1 TO length(ustr) DO
			FOR s := 1 TO length(str) DO BEGIN
				o := p;	p := PosEx(ustr[u],str,s);
				IF (p>o) THEN INC(frequencies[u]);
			END;
	END;

// Obtain the Shannon entropy of a string
FUNCTION entropy(s: STRING): EXTENDED;
	VAR pf : FArray;
		us : STRING;
		i,l: CARDINAL;
	BEGIN
		us := uniquechars(s);
		pf := frequencies(s,us);
		l  := length(s);
		entropy := 0.0;
		FOR i := 1 TO length(us) DO
			entropy -= pf[i]/l * log2(pf[i]/l);
	END;

BEGIN
	Writeln('Entropy of "',strng,'" is ',entropy(strng):2:5, ' bits.');
END.
