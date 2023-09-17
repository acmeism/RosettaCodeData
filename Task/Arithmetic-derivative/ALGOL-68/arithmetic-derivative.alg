BEGIN PROC lagarias = (LONG INT n) LONG INT: # Lagarias arithmetic derivative #
           IF n < 0
           THEN -lagarias (-n)
           ELIF n = 0 OR n = 1
           THEN 0
           ELIF PROC small pf = (LONG INT j, k) LONG INT: # Smallest prime factor #
                     (j %* k = 0 | k | small pf (j, k + 1));
                LONG INT f = small pf (n, 2); LONG INT q = n % f;
                q = 1
           THEN 1
           ELSE q * lagarias (f) + f * lagarias (q)
           FI;

      FOR n FROM -99 TO 100
      DO print (("D(", whole (n, 0), ") = ", whole (lagarias (n), 0), new line))
      OD;
      new line (standout);
      FOR n TO 20
      DO LONG INT m = LONG 10 ^ n;
         print (("D(", whole (m, 0), ") / 7 = ", whole (lagarias (m) % 7, 0), new line))
      OD
END
