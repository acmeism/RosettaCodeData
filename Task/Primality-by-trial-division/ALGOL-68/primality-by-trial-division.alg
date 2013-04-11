main:(
  INT upb=100;
  printf(($" The primes up to "g(-3)" are:"l$,upb));
  FOR i TO upb DO
    IF is prime(i) THEN
      printf(($g(-4)$,i))
    FI
  OD;
  printf($l$)
)
