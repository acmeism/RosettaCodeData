BEGIN
   PROC gcd = (INT m, n) INT :
   BEGIN
      INT a := ABS m, b := ABS n;
      IF a=0 OR b=0 THEN 0 ELSE
	 WHILE b /= 0 DO INT t = b; b := a MOD b; a := t OD;
	 a
      FI
   END;
   PROC lcm = (INT m, n) INT : ( m*n = 0 | 0 | ABS (m*n) % gcd (m, n));
   INT m=12, n=18;
   printf (($gxg(0)3(xgxg(0))l$,
	    "The least common multiple of", m, "and", n, "is", lcm(m,n),
	    "and their greatest common divisor is", gcd(m,n)))
END
