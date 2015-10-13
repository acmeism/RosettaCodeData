BEGIN
   [0:max abs char]INT histogram;
   FOR i FROM 0 TO max abs char DO histogram[i] := 0 OD;
   FILE input file;
   STRING input file name = "Letter_frequency.a68";
   IF open (input file, input file name, stand in channel) /= 0 THEN
      put (stand error, ("Cannot open ", input file name, newline));
      stop
   ELSE
      on file end (input file, (REF FILE f) BOOL: (close (f); GOTO finished))
   FI;
   DO
      STRING s;
      get (input file, (s, newline));
      FOR i TO UPB s DO
	 CHAR c = s[i];
	 IF "A" <= c AND c <= "Z" OR "a" <= c AND c <= "z" THEN
	    histogram[ABS c] PLUSAB 1
	 FI
     OD
   OD;
   close (input file);
finished:
   FOR i FROM ABS "A" TO ABS "Z" DO printf (($a3xg(0)l$, REPR i, histogram[i])) OD;
   FOR i FROM ABS "a" TO ABS "z" DO printf (($a3xg(0)l$, REPR i, histogram[i])) OD
END
