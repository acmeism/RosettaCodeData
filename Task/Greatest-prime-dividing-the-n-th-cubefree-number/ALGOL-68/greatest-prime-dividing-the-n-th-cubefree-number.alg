BEGIN # find the largest prime factor of some cubefree numbers - translation of EasyLang #
   PROC maxprimcubefree = ( INT numin )INT: BEGIN
      INT num := numin, t := 2, count := 0;
      WHILE t * t <= num DO
         IF num MOD t = 0 THEN
            count +:= 1;
            IF count = 3 THEN
               num := 0
            FI;
            num OVERAB t
         ELSE
            count := 0;
            t +:= IF ODD t THEN 2 ELSE 1 FI
         FI
      OD;
      IF count = 2 AND t = num THEN
         num := 0
      FI;
      num
   END;
   INT i := 1, a count := 0;
   WHILE a count < 100 DO
      INT h = maxprimcubefree( i );
      IF h /= 0 THEN
         a count +:= 1;
         print( ( whole( h, 0 ), " " ) )
      FI;
      i +:= 1
   OD;
   print( ( newline ) );
   WHILE a count < 100 000 DO
      INT h = maxprimcubefree( i );
      IF h /= 0 THEN
         a count +:= 1;
         IF a count = 1 000 OR a count = 10 000 OR a count = 100 000 THEN
            print( ( whole( h, 0 ), newline ) )
         FI
      FI;
      i +:= 1
   OD
END
