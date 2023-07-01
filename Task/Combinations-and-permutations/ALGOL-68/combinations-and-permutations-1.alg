# -*- coding: utf-8 -*- #

COMMENT REQUIRED by "prelude_combinations_and_permutations.a68" CO
  MODE CPINT = #LONG# ~;
  MODE CPOUT = #LONG# ~; # the answer, can be REAL #
  MODE CPREAL = ~; # the answer, can be REAL #
  PROC cp fix value error = (#REF# CPARGS args)BOOL: ~;
#PROVIDES:#
# OP C = (CP~,CP~)CP~: ~ #
# OP P = (CP~,CP~)CP~: ~ #
END COMMENT

MODE CPARGS = STRUCT(CHAR name, #REF# CPINT n,k);

PRIO C = 8, P = 8; # should be 7.5, a priority between *,/ and **,SHL,SHR etc #

# I suspect there is a more reliable way of doing this using the Gamma Function approx #

OP P = (CPINT n, r)CPOUT: (
  IF n < r ORF r < 0 THEN IF NOT cp fix value error(CPARGS("P",n,r)) THEN stop FI FI;
  CPOUT out := 1;
# basically nPk = (n-r+1)(n-r+2)...(n-2)(n-1)n = n!/(n-r)! #
  FOR i FROM n-r+1 TO n DO out *:= i OD;
  out
);

OP P = (CPREAL n, r)CPREAL: # 'ln gamma' requires GSL library #
  exp(ln gamma(n+1)-ln gamma(n-r+1));

# basically nPk = (n-r+1)(n-r+2)...(n-2)(n-1)n = n!/(n-r)! #
COMMENT # alternate slower version #
OP P = (CPREAL n, r)CPREAL: ( # alternate slower version #
  IF n < r ORF r < 0 THEN IF NOT cp fix value error(CPARGS("P",ENTIER n,ENTIER r)) THEN stop FI FI;
  CPREAL out := 1;
# basically nPk = (n-r+1)(n-r+2)...(n-2)(n-1)n = n!/(n-r)! #
  CPREAL i := n-r+1;
  WHILE i <= n DO
    out*:= i;
# a crude check for underflow #
    IF i = i + 1 THEN IF NOT cp fix value error(CPARGS("P",ENTIER n,ENTIER r)) THEN stop FI FI;
    i+:=1
  OD;
  out
);
END COMMENT

# basically C(n,r) = nCk = nPk/r! = n!/(n-r)!/r! #
OP C = (CPINT n, r)CPOUT: (
  IF n < r ORF r < 0 THEN IF NOT cp fix value error(("C",n,r)) THEN stop FI FI;
  CPINT largest = ( r > n - r | r | n - r );
  CPINT smallest = n - largest;
  CPOUT out := 1;
  INT smaller fact := 2;
  FOR larger fact FROM largest+1 TO n DO
# try and prevent overflow, p.s. there must be a smarter way to do this #
#   Problems: loop stalls when 'smaller fact' is a largeish co prime #
    out *:= larger fact;
    WHILE smaller fact <= smallest ANDF out MOD smaller fact = 0 DO
      out OVERAB smaller fact;
      smaller fact +:= 1
    OD
  OD;
  out # EXIT with: n P r OVER r P r #
);

OP C = (CPREAL n, CPREAL r)CPREAL: # 'ln gamma' requires GSL library #
  exp(ln gamma(n+1)-ln gamma(n-r+1)-ln gamma(r+1));

# basically C(n,r) = nCk = nPk/r! = n!/(n-r)!/r! #
COMMENT # alternate slower version #
OP C = (CPREAL n, REAL r)CPREAL: (
  IF n < r ORF r < 0 THEN IF NOT cp fix value error(("C",ENTIER n,ENTIER r)) THEN stop FI FI;
  CPREAL largest = ( r > n - r | r | n - r );
  CPREAL smallest = n - largest;
  CPREAL out := 1;
  REAL smaller fact := 2;
  REAL larger fact := largest+1;
  WHILE larger fact <= n DO # todo: check underflow here #
# try and prevent overflow, p.s. there must be a smarter way to do this #
    out *:= larger fact;
    WHILE smaller fact <= smallest ANDF out > smaller fact DO
      out /:= smaller fact;
      smaller fact +:= 1
    OD;
    larger fact +:= 1
  OD;
  out # EXIT with: n P r OVER r P r #
);
END COMMENT

SKIP
