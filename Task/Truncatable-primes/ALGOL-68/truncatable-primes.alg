#!/usr/local/bin/a68g --script #

PROC is prime = (INT n)BOOL:(
  []BOOL is short prime=(FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, FALSE);
  IF n<=UPB is short prime THEN is short prime[n] # EXIT # ELSE
    IF ( NOT ODD n | TRUE | n MOD 3 = 0 ) THEN FALSE # EXIT # ELSE
      INT h := ENTIER sqrt(n)+3;
      FOR a FROM 7 BY 6 WHILE a<h DO
        IF ( n MOD a = 0 | TRUE |  n MOD (a-2) = 0 ) THEN false exit FI
      OD;
      TRUE # EXIT #
    FI
  FI EXIT
  false exit: FALSE
);

PROC string to int = (STRING in a)INT:(
  FILE f; STRING a := in a; associate(f, a);
  INT i; get(f, i); close(f);
  i
);

PROC is trunc prime = (INT in n, PROC(REF STRING)VOID trunc)BOOL: (
  INT n := in n;
  STRING s := whole(n, 0);
  IF char in string("0", NIL, s) THEN FALSE # EXIT #
  ELSE
    WHILE is prime(n) DO
      s := whole(n, 0);
      trunc(s);
      IF UPB s = 0 THEN true exit FI;
      n := string to int(s)
    OD;
    FALSE EXIT
    true exit: TRUE
  FI
);

PROC get trunc prime = (INT in n, PROC(REF STRING)VOID trunc)VOID:(
  FOR n FROM in n BY -1 TO 1 DO
    IF is trunc prime(n, trunc) THEN
      printf(($g(0)l$, n));
      break
    FI
  OD;
  break: ~
);

main:(
  INT limit = 1000000;
  printf(($g g(0) gl$,"Highest left- and right-truncatable primes under ",limit,":"));
  get trunc prime(limit, (REF STRING s)VOID: s := s[LWB s+1:]);
  get trunc prime(limit, (REF STRING s)VOID: s := s[:UPB s-1]);
  write("Press Enter");
  read(newline)
)
