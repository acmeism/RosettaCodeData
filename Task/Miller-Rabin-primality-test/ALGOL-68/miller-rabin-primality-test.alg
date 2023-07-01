MODE LINT=LONG INT;
MODE LOOPINT = INT;

MODE POWMODSTRUCT = LINT;
PR READ "prelude/pow_mod.a68" PR;

PROC miller rabin = (LINT n, LOOPINT k)BOOL: (
    IF n<=3 THEN TRUE
    ELIF NOT ODD n THEN FALSE
    ELSE
        LINT d := n - 1;
        INT s := 0;
        WHILE NOT ODD d DO
            d := d OVER 2;
            s +:= 1
        OD;
        TO k DO
            LINT a := 2 + ENTIER (random*(n-3));
            LINT x :=  pow mod(a, d, n);
            IF x /= 1 THEN
                TO s DO
                    IF x = n-1 THEN done FI;
                    x := x*x %* n
                OD;
                else: IF x /= n-1 THEN return false FI;
                done: EMPTY
            FI
        OD;
        TRUE EXIT
        return false: FALSE
    FI
);

FOR i FROM 937 TO 1000 DO
  IF miller rabin(i, 10) THEN
    print((" ",whole(i,0)))
  FI
OD
