BEGIN # find Duffinian numbers: non-primes relatively prime to their divisor count #
    INT max number            := 500 000;      # largest number we will consider   #
    # iterative Greatest Common Divisor routine, returns the gcd of m and n        #
    PROC gcd = ( INT m, n )INT:
         BEGIN
            INT a := ABS m, b := ABS n;
            WHILE b /= 0 DO
                INT new a = b;
                b        := a MOD b;
                a        := new a
            OD;
            a
         END # gcd # ;
    # construct a table of the divisor counts                                      #
    [ 1 : max number ]INT ds; FOR i TO UPB ds DO ds[ i ] := 1 OD;
    FOR i FROM 2 TO UPB ds
        DO FOR j FROM i BY i TO UPB ds DO ds[ j ] +:= i OD
    OD;
    # set the divisor counts of non-Duffinian numbers to 0                         #
    ds[ 1 ] := 0;  # 1 is not Duffinian                                            #
    FOR n FROM 2 TO UPB ds DO
        IF INT nds = ds[ n ];
           IF nds = n + 1 THEN TRUE ELSE gcd( n, nds ) /= 1 FI
        THEN
            # n is prime or is not relatively prime to its divisor sum             #
            ds[ n ] := 0
        FI
    OD;
    # show the first 50 Duffinian numbers                                          #
    print( ( "The first 50 Duffinian numbers:", newline ) );
    INT dcount := 0;
    FOR n WHILE dcount < 50 DO
        IF ds[ n ] /= 0
        THEN # found a Duffinian number                                            #
            print( ( " ", whole( n, -3) ) );
            IF ( dcount +:= 1 ) MOD 25 = 0 THEN print( ( newline ) ) FI
        FI
    OD;
    print( ( newline ) );
    # show the duffinian triplets below UPB ds                                     #
    print( ( "The Duffinian triplets up to ", whole( UPB ds, 0 ), ":", newline ) );
    dcount := 0;
    FOR n FROM 3 TO UPB ds DO
        IF ds[ n - 2 ] /= 0 AND ds[ n - 1 ] /= 0 AND ds[ n ] /= 0
        THEN # found a Duffinian triplet                                           #
            print( ( " (", whole( n - 2, -7 ), " ", whole( n - 1, -7 ), " ", whole( n, -7 ), ")" ) );
            IF ( dcount +:= 1 ) MOD 4 = 0 THEN print( ( newline ) ) FI
        FI
    OD
END
