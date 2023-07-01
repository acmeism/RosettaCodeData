MODE ISPRIMEINT = INT;
PR READ "prelude/is_prime.a68" PR;

MODE POWMODSTRUCT = INT;
PR READ "prelude/pow_mod.a68" PR;

PROC m factor = (INT p)INT:BEGIN
  INT m factor;
  INT max k, msb, n, q;

  FOR i FROM bits width - 2 BY -1 TO 0 WHILE ( BIN p SHR i AND 2r1 ) = 2r0 DO
      msb := i
  OD;

  max k := ENTIER sqrt(max int) OVER p; # limit for k to prevent overflow of max int #
  FOR k FROM 1 TO max k DO
    q := 2*p*k + 1;
    IF NOT is prime(q) THEN
      SKIP
    ELIF q MOD 8 /= 1 AND q MOD 8 /= 7 THEN
      SKIP
    ELSE
      n := pow mod(2,p,q);
      IF n = 1 THEN
        m factor := q;
        return
      FI
    FI
  OD;
  m factor := 0;
  return:
    m factor
END;

BEGIN

  INT exponent, factor;
  print("Enter exponent of Mersenne number:");
  read(exponent);
  IF NOT is prime(exponent) THEN
    print(("Exponent is not prime: ", exponent, new line))
  ELSE
    factor := m factor(exponent);
    IF factor = 0 THEN
      print(("No factor found for M", exponent, new line))
    ELSE
      print(("M", exponent, " has a factor: ", factor, new line))
    FI
  FI

END
