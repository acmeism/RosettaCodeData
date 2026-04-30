BEGIN
  PROC gcd = (INT m, n) INT: (
    IF INT a = ABS m, b = ABS n;
      a = 0
    THEN
      b
    ELIF b = 0 THEN
      a
    ELIF a > b  THEN
      gcd(b, a MOD b)
    ELSE
      gcd(a, b MOD a)
    FI
  );
  test:(
    FOR a FROM 33 BY -33 TO -33 DO
      FOR b FROM 77 BY -77 TO -77 DO
        print(("The gcd of ", whole(a,-6)," and ", whole(b,-6)," is ", whole(gcd(a,b),-6),newline))
      OD
    OD;
    INT c = 49865, d = 69811;
    print(("The gcd of ", whole(c,-6)," and ", whole(d,-6)," is ", whole(gcd(c,d),-6),newline))
  )
END
