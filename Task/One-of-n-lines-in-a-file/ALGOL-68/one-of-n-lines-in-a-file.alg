BEGIN
   INT max lines = 10;		CO Should be read from a file. CO
   [max lines]INT stats;
   FOR i TO max lines DO stats[i] := 0 OD;
   first random (42);		CO Should have rather more entropy! CO
   PROC one of n = (INT n) INT :
   BEGIN
      INT result := 1;
      FOR i TO n DO (random < 1/i | result := i) OD;
      result
   END;
   TO 1000000 DO stats[one of n (max lines)] +:= 1 OD;
   print (("Line  Number times chosen", newline));
   FOR i TO max lines DO printf (($g(0)7xg(0)l$, i, stats[i])) OD
END
