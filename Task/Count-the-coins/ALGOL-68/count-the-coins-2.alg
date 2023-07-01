#
   Rosetta Code "Count the coins"
   This uses what I believe are the ideas behind the "much faster, probably
   harder to read" Haskell version.
#

BEGIN
   PROC ways to make change = ([] INT denoms, INT amount) LONG INT:
   BEGIN
      [0:amount] LONG INT counts, new counts;

      FOR i FROM 0 TO amount DO counts[i] := (i = 0 | 1 | 0) OD;

      FOR i FROM LWB denoms TO UPB denoms DO
         INT denom = denoms[i];
         FOR j FROM 0 TO amount DO new counts[j] := 0 OD;
         FOR j FROM 0 TO amount DO
            IF LONG INT count = counts[j]; count > 0 THEN
               FOR k FROM j + denom BY denom TO amount DO
                  new counts[k] +:= count
               OD
            FI;
            counts[j] +:= new counts[j]
         OD
      OD;
      counts[amount]
   END;

   print((ways to make change((1, 5, 10, 25), 100), newline));
   print((ways to make change((1, 5, 10, 25, 50, 100), 10000), newline));
   print((ways to make change((1, 5, 10, 25, 50, 100), 100000), newline))
END
