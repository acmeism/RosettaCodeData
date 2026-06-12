BEGIN
    INT  a = 1 234 567;
    REAL b = 3      .    1 4159 26 5 359;
    print( ( whole( a, 0 ), "  ", fixed( b, - 14, 11 ), newline ) )
END
