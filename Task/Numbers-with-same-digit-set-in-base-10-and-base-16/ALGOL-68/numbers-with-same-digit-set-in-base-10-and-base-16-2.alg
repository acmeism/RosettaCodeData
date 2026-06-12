BEGIN # find numbers with the same digit set in base 10 and base 16 #
      #      translation of the EasyLang sample                     #
    PROC digit set = ( INT n in, b )BITS:
         BEGIN
            INT  n    := n in;
            BITS dset := 16r0;
            WHILE n > 0 DO
                BITS h = 16r1 SHL ( n MOD b );
                dset := dset OR h;
                n OVERAB b
            OD;
            dset
         END # digit set # ;

    INT max number = 100 000;
    INT hd count := 0;
    FOR i FROM 0 TO max number - 1 DO
        IF digit set( i, 10 ) = digit set( i, 16 ) THEN
            print( ( " ", whole( i, -7 ) ) );
            IF ( hd count +:= 1 ) MOD 10 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline ) );
    print( ( "Found ", whole( hd count, 0 ), " numbers up to ", whole( max number, 0 ) ) );
    print( ( " where the decimal and hexadecimal representations use the same digits", newline ) )
END
