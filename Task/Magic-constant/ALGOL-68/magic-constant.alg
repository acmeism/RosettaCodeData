BEGIN # find some magic constants - the row, column and diagonal sums of a magin square #
      # translation of the Free Basic sample with the Julia/Wren inverse function #
    # returns the magic constant of a magic square of order n + 2 #
    PROC a     = ( INT n )LONG LONG INT:
         BEGIN
            LONG LONG INT n2 = n + 2;
            ( n2 * ( ( n2 * n2 ) + 1 ) ) OVER 2
         END # a # ;
    # returns the order of the magic square whose magic constant is at least x #
    PROC inv a = ( LONG LONG INT x )LONG LONG INT:
         ENTIER long long exp( long long ln( x * 2 ) / 3 ) + 1;

    print( ( "The first 20 magic constants are " ) );
    FOR n TO 20 DO
        print( ( whole( a( n ), 0 ), " " ) )
    OD;
    print( ( newline ) );
    print( ( "The 1,000th magic constant is ", whole( a( 1000 ), 0 ), newline ) );
    LONG LONG INT e := 1;
    FOR n TO 20 DO
        e *:= 10;
        print( ( "10^", whole( n, -2 ), ": ", whole( inv a( e ), -9 ), newline ) )
    OD
END
