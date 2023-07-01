INT match=0, no match=1, out of memory error=2, other error=3;

STRING str := "i am a string";

# Match: #

STRING m := "string$";
INT start, end;
IF grep in string(m, str, start, end) = match THEN printf(($"Ends with """g""""l$, str[start:end])) FI;

# Replace: #

IF sub in string(" a ", " another ",str) = match THEN printf(($gl$, str)) FI;
