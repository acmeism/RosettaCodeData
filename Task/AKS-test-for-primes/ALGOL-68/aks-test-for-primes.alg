BEGIN
COMMENT
   Mathematical preliminaries.

   First note that the homogeneous polynomial (a+b)^n is symmetrical
   (to see this just swap the variables a and b).  Therefore its
   coefficients need be calculated only to that of (ab)^{n/2} for even
   n or (ab)^{(n-1)/2} for odd n.

   Second, the coefficients are the binomial coefficients C(n,k) where
   the coefficient of a^k b^(n-k) is C(n,k) = n! / k!  (k-1)!.  This
   leads to an immediate and relatively efficient implementation for
   which we do not need to compute n! before dividing by k! and (k-1)!
   but, rather cancel common factors as we go along.  Further, the
   well-known symmetry identity C(n,k) = C(n, n-k) allows a
   significant reduction in computational effort.

   Third, (x-1)^n is the value of (a + b)^n when a=x and b = -1.  The
   powers of -1 alternate between +1 and -1 so we may as well compute
   (x+1)^n and negate every other coefficient when printing.
COMMENT
   PR precision=300 PR
   MODE LLI = LONG LONG INT;	CO For brevity CO
   PROC choose = (INT n, k) LLI :
   BEGIN
      LLI result := 1;
      INT sym k := (k >= n%2 | n-k | k);	CO Use symmetry CO
      IF sym k > 0 THEN
	 FOR i FROM 0 TO sym k-1
	 DO
	    result TIMESAB (n-i);
	    result OVERAB (i+1)
	 OD
      FI;
      result
   END;
   PROC coefficients = (INT n) [] LLI :
   BEGIN
      [0:n] LLI a;
      FOR i FROM 0 TO n%2
      DO
	 a[i] := a[n-i] := choose (n, i)		CO Use symmetry CO
      OD;
      a
   END;
COMMENT
   First print the polynomials (x-1)^n, remembering to alternate signs
   and to tidy up the constant term, the x^1 term and the x^n term.
   This means we must treat (x-1)^0 and (x-1)^1 specially
COMMENT
   FOR n FROM 0 TO 7
   DO
      [0:n] LLI a := coefficients (n);
      printf (($"(x-1)^", g(0), " = "$, n));
      CASE n+1 IN
         printf (($g(0)l$, a[0])),
         printf (($"x - ", g(0)l$, a[1]))
      OUT
         printf (($"x^", g(0)$, n));
         FOR i TO n-2
         DO
	    printf (($xax, g(0), "x^", g(0)$, (ODD i | "-" | "+"), a[i], n-i))
         OD;
         printf (($xax, g(0), "x"$, (ODD (n-1) | "-" | "+"), a[n-1]));
         printf (($xaxg(0)l$, (ODD n | "-" | "+"), a[n]))
      ESAC
OD;
COMMENT
   Finally, for the "AKS" portion of the task, the sign of the
   coefficient has no effect on its divisibility by p so, once again,
   we may as well use the positive coefficients.  Symmetry clearly
   reduces the necessary number of tests by a factor of two.
COMMENT
   PROC is prime = (INT n) BOOL :
   BEGIN
      BOOL prime := TRUE;
      FOR i FROM 1 TO n%2 WHILE prime DO prime := choose (n, i) MOD n = 0 OD;
      prime
   END;
   print ("Primes < 50 are ");
   FOR n FROM 2 TO 50 DO (is prime (n) | printf (($g(0)x$, n)) ) OD;
   print (newline);
   print ("And just to show off, the primes between 900 and 1000 are ");
   FOR n FROM 900 TO 1000 DO IF is prime (n) THEN printf (($g(0)x$, n)) FI OD;
   print (newline)
END
