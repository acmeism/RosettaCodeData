BEGIN
  PROC is prime = ( INT p )BOOL:
    IF p <= 1 OR ( NOT ODD p AND p/= 2) THEN
      FALSE
    ELSE
      BOOL prime := TRUE;
      FOR i FROM 3 BY 2 TO ENTIER sqrt(p)
        WHILE prime := p MOD i /= 0 DO SKIP OD;
      prime
    FI;

  INT upb=100;
  print((" The primes up to ", whole(upb,-3) ," are:"));
  FOR i TO upb DO
    IF is prime(i) THEN
      print((" ",whole(i,0)))
    FI
  OD;
  print((newline))
END
