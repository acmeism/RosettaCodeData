#!/usr/local/bin/a68g --script #

MODE FIELD=LONG REAL;
PROC (FIELD)FIELD field sqrt = long sqrt;
INT field prec = 5;
FORMAT field fmt = $g(-(2+1+field prec),field prec)$;

MODE MAT = [0,0]FIELD;

PROC cholesky = (MAT a) MAT:(
    [UPB a, 2 UPB a]FIELD l;

    FOR i FROM LWB a TO UPB a DO
        FOR j FROM 2 LWB a TO i DO
            FIELD s := 0;
            FOR k FROM 2 LWB a TO j-1 DO
                s +:= l[i,k] * l[j,k]
            OD;
            l[i,j] := IF i = j
                      THEN field sqrt(a[i,i] - s)
                      ELSE 1.0 / l[j,j] * (a[i,j] - s) FI
        OD;
        FOR j FROM i+1 TO 2 UPB a DO
            l[i,j]:=0 # Not required if matrix is declared as triangular #
        OD
    OD;
    l
);

PROC print matrix v1 =(MAT a)VOID:(
    FOR i FROM LWB a TO UPB a DO
        FOR j FROM 2 LWB a TO 2 UPB a DO
            printf(($g(-(2+1+field prec),field prec)$, a[i,j]))
        OD;
        printf($l$)
    OD
);

PROC print matrix =(MAT a)VOID:(
    FORMAT vector fmt = $"("f(field  fmt)n(2 UPB a-2 LWB a)(", " f(field  fmt))")"$;
    FORMAT matrix fmt = $"("f(vector fmt)n(  UPB a-  LWB a)(","lxf(vector fmt))")"$;
    printf((matrix fmt, a))
);

main: (
    MAT m1 = ((25, 15, -5),
              (15, 18,  0),
              (-5,  0, 11));
    MAT c1 = cholesky(m1);
    print matrix(c1);
    printf($l$);

    MAT m2 = ((18, 22,  54,  42),
              (22, 70,  86,  62),
              (54, 86, 174, 134),
              (42, 62, 134, 106));
    MAT c2 = cholesky(m2);
    print matrix(c2)
)
