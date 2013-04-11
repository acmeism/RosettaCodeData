PROC zig zag = (INT n)[,]INT: (
    PROC move = (REF INT i, j)VOID: (
        IF j < n THEN
            i := ( i <= 1 | 1 | i-1 );
            j +:= 1
        ELSE
            i +:= 1
        FI
    );

    [n, n]INT a;
    INT x:=LWB a, y:=LWB a;

    FOR v FROM 0 TO n**2-1 DO
        a[y, x] := v;
        IF ODD (x + y) THEN
            move(x, y)
        ELSE
            move(y, x)
        FI
    OD;
    a
);

INT dim = 5;
#IF formatted transput possible THEN
  FORMAT d = $z-d$;
  FORMAT row = $"("n(dim-1)(f(d)",")f(d)")"$;
  FORMAT block = $"("n(dim-1)(f(row)","lx)f(row)")"l$;

  printf((block, zig zag(dim)))
ELSE#
  [,]INT result = zig zag(dim);
  FOR i TO dim DO
    print((result[i,], new line))
  OD
#FI#
