MODE LOOPINT = INT;

MODE POWMODSTRUCT = LONG INT;
PR READ "prelude/pow_mod.a68" PR;

MODE SORTSTRUCT = LONG INT;
PR READ "prelude/sort.a68" PR;

MODE GCDSTRUCT = LONG INT;
PR READ "prelude/gcd.a68" PR;

PR READ "prelude/iterator.a68" PR;

PROC is prime = (LONG INT p)BOOL:
    ( p > 1 |#ANDF# ALL((YIELDBOOL yield)VOID: factored(p, (LONG INT f, LONG INT e)VOID: yield(f = p))) | FALSE );

FLEX[4]LONG INT prime list := (2,3,5,7);

OP +:= = (REF FLEX[]LONG INT lhs, LONG INT rhs)VOID: (
    [UPB lhs +1] LONG INT next lhs;
    next lhs[:UPB lhs] := lhs;
    lhs := next lhs;
    lhs[UPB lhs] := rhs
);

PROC primes = (PROC (LONG INT)VOID yield)VOID: (
    LONG INT p;
    FOR p index TO UPB prime list DO
        p:= prime list[p index];
        yield(p)
    OD;
    DO
        p +:= 2;
        WHILE NOT is prime(p) DO
            p +:= 2
        OD;
        prime list +:= p;
        yield(p)
    OD
);

PROC factored = (LONG INT in a, PROC (LONG INT,LONG INT)VOID yield)VOID: (
    LONG INT a := in a;
  # FOR          p IN  # primes( # DO #
       (LONG INT p)VOID:(
        LONG INT j := 0;
        WHILE a MOD p = 0 DO
            a := a % p;
            j +:= 1
        OD;
        IF j > 0 THEN yield (p,j) FI;
        IF a < p*p THEN done FI
      )
  # ) OD #  );
    done:
    IF a > 1 THEN yield (a,1) FI
);

PROC mult0rdr1 = (LONG INT a, p, e)LONG INT: (
    LONG INT m := p ** SHORTEN e;
    LONG INT t := (p-1)*(p**SHORTEN (e-1)); #  = Phi(p**e) where p prime #
    LONG INT q;
    FLEX[0]LONG INT qs := (1);
  # FOR          f0,f1 IN  # factored(t # DO #,
       (LONG INT f0,f1)VOID: (
            FLEX[SHORTEN((f1+1)*UPB qs)]LONG INT next qs;
            FOR j TO SHORTEN f1 + 1 DO
                FOR q index TO UPB qs DO
                    q := qs[q index];
                    next qs[(j-1)*UPB qs+q index] := q * f0**(j-1)
                OD
            OD;
            qs := next qs
        )
  #   OD # );
    VOID(in place shell sort(qs));

    FOR q index TO UPB qs DO
        q := qs[q index];
        IF pow mod(a,q,m)=1 THEN done FI
    OD;
    done:
    q
);

PROC reduce = (PROC (LONG INT,LONG INT)LONG INT diadic, FORLONGINT iterator, LONG INT initial value)LONG INT: (
  LONG INT out := initial value;
# FOR          next IN # iterator( # DO #
     (LONG INT next)VOID:
    out := diadic(out, next)
 # OD # );
  out
);

PROC mult order = (LONG INT a, LONG INT m)LONG INT: (
    PROC mofs = (YIELDLONGINT yield)VOID:(
      # FOR          p,          count IN # factored(m, # DO #
           (LONG INT p, LONG INT count)VOID:
            yield(mult0rdr1(a,p,count))
        )
  # OD #  );
    reduce(lcm, mofs, 1)
);

main:(
    FORMAT d = $g(-0)$;
    printf((d, mult order(37, 1000), $l$));        # 100 #
    LONG INT b := LENG 10**20-1;
    printf((d, mult order(2, b), $l$)); # 3748806900 #
    printf((d, mult order(17,b), $l$)); # 1499522760 #
    b := 100001;
    printf((d, mult order(54,b), $l$));
    printf((d, pow mod( 54, mult order(54,b),b), $l$));
    IF ANY( (YIELDBOOL yield)VOID: FOR r FROM 2 TO SHORTEN mult order(54,b)-1 DO yield(1=pow mod(54,r, b)) OD  )
    THEN
        printf(($g$, "Exists a power r < 9090 where pow mod(54,r,b) = 1", $l$))
    ELSE
        printf(($g$, "Everything checks.", $l$))
    FI
)
