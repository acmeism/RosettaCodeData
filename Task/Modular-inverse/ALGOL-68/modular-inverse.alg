BEGIN
   PROC modular inverse = (INT a, m) INT :
   BEGIN
      PROC extended gcd = (INT x, y) []INT :
CO
   Algol 68 allows us to return three INTs in several ways.  A [3]INT
   is used here but it could just as well be a STRUCT.
CO
      BEGIN
	 INT v := 1, a := 1, u := 0, b := 0, g := x, w := y;
	 WHILE w>0
	 DO
	    INT q := g % w, t := a - q * u;
	    a := u; u := t;
	    t := b - q * v;
	    b := v; v := t;
	    t := g - q * w;
	    g := w; w := t
	 OD;
	 a PLUSAB (a < 0 | u | 0);
	 (a, b, g)
      END;
      [] INT egcd = extended gcd (a, m);
      (egcd[3] > 1 | 0 | egcd[1] MOD m)
   END;
   printf (($"42 ^ -1 (mod 2017) = ", g(0)$, modular inverse (42, 2017)))
CO
   Note that if ϕ(m) is known, then a^-1 = a^(ϕ(m)-1) mod m which
   allows an alternative implementation in terms of modular
   exponentiation but, in general, this requires the factorization of
   m.  If m is prime the factorization is trivial and ϕ(m) = m-1.
   2017 is prime which may, or may not, be ironic within the context
   of the Rosetta Code conditions.
CO
END
