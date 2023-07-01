PROC long next random = (REF LONG INT a)LONG REAL: # some suitable next random number #;
INT long last random := # some initial random number #;
PROC long random = LONG REAL: long next random(long last random);
