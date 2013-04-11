#IF long int possible THEN #

MODE LINT = LONG INT;
LINT lmax int = long max int;
OP LLENG = (INT i)LINT: LENG i,
   LSHORTEN = (LINT i)INT: SHORTEN i;

#ELSE

MODE LINT = INT;
LINT lmax int = max int;
OP LLENG = (INT i)LINT: i,
   LSHORTEN = (LINT i)INT: i;

FI#

OP LLONG = (INT i)LINT: LLENG i;

MODE YIELDLINT = PROC(LINT)VOID;

PROC (LINT, YIELDLINT)VOID gen decompose;

INT upb cache = bits width;

BITS cache := 2r0;
BITS cached := 2r0;

PROC is prime = (LINT n)BOOL: (
    BOOL
        has factor := FALSE,
        out := TRUE;
  # FOR LINT factor IN # gen decompose(n, # ) DO ( #
  ##   (LINT factor)VOID:(
      IF has factor THEN out := FALSE; GO TO done FI;
      has factor := TRUE
  # OD # ));
    done: out
);

PROC is prime cached := (LINT n)BOOL: (
    LINT l half n = n OVER LLONG 2 - LLONG 1;
    IF l half n <= LLENG upb cache THEN
        INT half n = LSHORTEN l half n;
        IF half n ELEM cached THEN
            BOOL(half n ELEM cache)
        ELSE
            BOOL out = is prime(n);
            BITS mask = 2r1 SHL (upb cache - half n);
            cached := cached OR mask;
            IF out THEN cache := cache OR mask FI;
            out
        FI
    ELSE
        is prime(n) # above useful cache limit #
    FI
);


PROC gen primes := (YIELDLINT yield)VOID:(
    yield(LLONG 2);
    LINT n := LLONG 3;
    WHILE n < l maxint - LLONG 2 DO
        yield(n);
        n +:= LLONG 2;
        WHILE n < l maxint - LLONG 2 AND NOT is prime cached(n) DO
            n +:= LLONG 2
        OD
    OD
);

# PROC # gen decompose := (LINT in n, YIELDLINT yield)VOID: (
    LINT n := in n;
  # FOR LINT p IN # gen primes( # ) DO ( #
  ##   (LINT p)VOID:
        IF p*p > n THEN
            GO TO done
        ELSE
            WHILE n MOD p = LLONG 0 DO
                yield(p);
                n := n OVER p
            OD
        FI
  # OD #  );
    done:
    IF n > LLONG 1 THEN
        yield(n)
    FI
);

main:(
# FOR LINT m IN # gen primes( # ) DO ( #
##   (LINT m)VOID:(
      LINT p = LLONG 2 ** LSHORTEN m - LLONG 1;
      print(("2**",whole(m,0),"-1 = ",whole(p,0),", with factors:"));
    # FOR LINT factor IN # gen decompose(p, # ) DO ( #
    ##   (LINT factor)VOID:
          print((" ",whole(factor,0)))
    # OD # );
      print(new line);
      IF m >= LLONG 59 THEN GO TO done FI
# OD #  ));
  done: EMPTY
)
