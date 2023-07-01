BEGIN
   INT examples=10, classes=5;
   MODE SEMIPRIME = STRUCT ([examples]INT data, INT count);
   [classes]SEMIPRIME semi primes;
   PROC num facs = (INT n) INT :
COMMENT
   Return number of not necessarily distinct prime factors of n.
   Not very efficient for large n ...
COMMENT
   BEGIN
      INT tf := 2, residue := n, count := 1;
      WHILE tf < residue DO
	 INT remainder = residue MOD tf;
	 ( remainder = 0 | count +:= 1; residue %:= tf | tf +:= 1 )
      OD;
      count
   END;
   PROC update table = (REF []SEMIPRIME table, INT i) BOOL :
COMMENT
   Add i to the appropriate row of the table, if any, unless that row
   is already full. Return a BOOL which is TRUE when all of the table
   is full.
COMMENT
   BEGIN
      INT k := num facs(i);
      IF k <= classes
      THEN
	 INT c = 1 + count OF table[k];
	 ( c <= examples | (data OF table[k])[c] := i; count OF table[k] := c )
      FI;
      INT sum := 0;
      FOR i TO classes DO sum +:= count OF table[i] OD;
      sum < classes * examples
   END;
   FOR i TO classes DO count OF semi primes[i] := 0 OD;
   FOR i FROM 2 WHILE update table (semi primes, i) DO SKIP OD;
   FOR i TO classes
   DO
      printf (($"k = ", d, ":", n(examples)(xg(0))l$, i, data OF semi primes[i]))
   OD
END
