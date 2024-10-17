BEGIN
    # calculate an approximation to e #
    LONG REAL epsilon = 1.0e-15;
    LONG INT  f := 1;
    LONG REAL e := 2;
    LONG INT  n := 2;
    WHILE
        LONG REAL e0 = e;
        f *:= n;
        n +:= 1;
        e +:= 1.0 / f;
        ABS ( e - e0 ) >= epsilon
    DO SKIP OD;
    print( ( "e = ", fixed( e, -17, 15 ), newline ) )
END
