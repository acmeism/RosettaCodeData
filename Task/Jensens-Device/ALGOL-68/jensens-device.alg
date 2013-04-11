BEGIN
   INT i;
   PROC sum  = (REF INT i, INT lo, hi, PROC REAL term)REAL:
      COMMENT term is passed by-name, and so is i COMMENT
   BEGIN
      REAL temp := 0;
      i := lo;
      WHILE i <= hi DO           # ALGOL 68 has a "for" loop but it creates a distinct #
         temp +:= term;          # variable which would not be shared with the passed "i" #
         i +:= 1                 # Here the actual passed "i" is incremented. #
      OD;
      temp
   END;
   COMMENT note the correspondence between the mathematical notation and the call to sum COMMENT
   print (sum (i, 1, 100, REAL: 1/i))
END
