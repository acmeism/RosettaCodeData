MODE LINT = # LONG ... # INT;

PROC hailstone = (INT in n, REF[]LINT array)INT:
(
    INT hs := 1;
    INT index := 0;
    LINT n := in n;

    WHILE n /= 1 DO
        hs +:= 1;
        IF array ISNT REF[]LINT(NIL) THEN array[index +:= 1] := n FI;
        n := IF ODD n THEN 3*n+1 ELSE n OVER 2 FI
    OD;
    IF array ISNT REF[]LINT(NIL) THEN array[index +:= 1] := n FI;
    hs
);

main:
(
    INT j, hmax := 0;
    INT jatmax, n;
    INT border = 4;

    FOR j TO 100000-1 DO
       n := hailstone(j, NIL);
       IF hmax < n THEN
           hmax := n;
           jatmax := j
       FI
    OD;

    [2]INT test := (27, jatmax);
    FOR key TO UPB test DO
        INT val = test[key];
        n := hailstone(val, NIL);
        [n]LINT array;
        n := hailstone(val, array);

        printf(($"[ "n(border)(g(0)", ")" ..."n(border)(", "g(0))"] len="g(0)l$,
            array[:border], array[n-border+1:], n))
        #;free(array) #
    OD;
    printf(($"Max "g(0)" at j="g(0)l$, hmax, jatmax))
# ELLA Algol68RS:
    print(("Max",hmax," at j=",jatmax, new line))
#
)
