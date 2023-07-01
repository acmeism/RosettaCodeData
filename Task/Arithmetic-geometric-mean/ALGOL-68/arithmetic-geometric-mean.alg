BEGIN
   PROC agm = (LONG REAL x, y) LONG REAL :
   BEGIN
      IF x < LONG 0.0 OR y < LONG 0.0 THEN -LONG 1.0
      ELIF x + y = LONG 0.0 THEN LONG 0.0		CO Edge cases CO
      ELSE
         LONG REAL a := x, g := y;
         LONG REAL epsilon := a + g;
         LONG REAL next a := (a + g) / LONG 2.0, next g := long sqrt (a * g);
         LONG REAL next epsilon := ABS (a - g);
         WHILE next epsilon < epsilon
         DO
            print ((epsilon, "   ", next epsilon, newline));
            epsilon := next epsilon;
            a := next a; g := next g;
            next a := (a + g) / LONG 2.0; next g := long sqrt (a * g);
            next epsilon := ABS (a - g)
         OD;
         a
      FI
   END;
   printf (($l(-35,33)l$, agm (LONG 1.0, LONG 1.0 / long sqrt (LONG 2.0))))
END
