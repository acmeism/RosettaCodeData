BOOL prime = TRUE, non prime = FALSE;
PROC eratosthenes = (INT n)[]BOOL:
(
  [n]BOOL sieve;
  FOR i TO UPB sieve DO sieve[i] := prime OD;
  INT m = ENTIER sqrt(n);
  sieve[1] := non prime;
  FOR i FROM 2 TO m DO
    IF sieve[i] = prime THEN
      FOR j FROM i*i BY i TO n DO
        sieve[j] := non prime
      OD
    FI
  OD;
  sieve
);

 print((eratosthenes(80),new line))
