PRAGMAT stack=1M precision=20000 PRAGMAT

PROC is prime = ( INT p )BOOL:
  IF p = 2 THEN TRUE
  ELIF p <= 1 OR p MOD 2 = 0 THEN FALSE
  ELSE
    BOOL prime := TRUE;
    FOR i FROM 3 BY 2 TO ENTIER sqrt(p)
      WHILE prime := p MOD i /= 0 DO SKIP OD;
    prime
  FI;

PROC is mersenne prime = ( INT p )BOOL:
  IF p = 2 THEN TRUE
  ELSE
    LONG LONG INT m p :=  LONG LONG 2 ** p - 1, s := 4;
    FROM 3 TO p DO
      s := (s ** 2 - 2) MOD m p
    OD;
    s = 0
  FI;

test:(
  INT upb prime = ( long long bits width - 1 ) OVER 2; # no unsigned #
  INT upb count = 45; # find 45 mprimes if INT has enough bits #

  printf(($" Finding Mersenne primes in M[2.."g(0)"]: "l$,upb prime));

  INT count:=0;
  FOR p FROM 2 TO upb prime WHILE
    IF is prime(p) THEN
      IF is mersenne prime(p) THEN
        printf (($" M"g(0)$,p));
        count +:= 1
      FI
    FI;
    count <= upb count
  DO SKIP OD
)
