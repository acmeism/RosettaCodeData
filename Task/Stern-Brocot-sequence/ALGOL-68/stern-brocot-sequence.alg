BEGIN # find members of the Stern-Brocot sequence: starting from 1, 1 the     #
      # subsequent members are the previous two members summed followed by    #
      # the previous                                                          #
    # iterative Greatest Common Divisor routine, returns the gcd of m and n   #
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
    # returns an array of the Stern-Brocot sequence up to n                   #
    OP   STERNBROCOT = ( INT n )[]INT:
         BEGIN
            [ 1 : IF ODD n THEN n + 1 ELSE n FI ]INT result;
            IF n > 0 THEN
                result[ 1 ]  := result[ 2 ] := 1;
                INT next pos := 2;
                FOR i FROM 3 WHILE next pos < n DO
                    INT p1 = result[ i - 1 ];
                    result[ next pos +:= 1 ] := p1 + result[ i - 2 ];
                    result[ next pos +:= 1 ] := p1
                OD
            FI;
            result[ 1 : n ]
         END # STERNPROCOT # ;
    FLEX[ 1 : 0 ]INT sb := STERNBROCOT 1000; # start with 1000 elements        #
                              # if that isn't enough, more will be added later #
    # show the first 15 elements of the sequence                               #
    print( ( "The first 15 elements of the Stern-Brocot sequence are:", newline ) );
    FOR i TO 15 DO
        print( ( whole( sb[ i ], -3 ) ) )
    OD;
    print( ( newline, newline ) );
    # find where the numbers 1-10 first appear                                 #
    INT found 10 := 0;
    [ 10 ]INT pos 10; FOR i TO UPB pos 10 DO pos 10[ i ] := 0 OD;
    FOR i TO UPB sb WHILE found 10 < 10 DO
        INT sb i = sb[ i ];
        IF sb i <= UPB pos 10 THEN
            IF pos 10[ sb i ] = 0 THEN
                # first occurance of this number                               #
                pos 10[ sb i ] := i;
                found 10      +:= 1
            FI
        FI
    OD;
    print( ( "The first positions of 1..", whole( UPB pos 10, 0 ), " in the sequence are:", newline ) );
    FOR i TO UPB pos 10 DO
        print( ( whole( i, -2 ), ":", whole( pos 10[ i ], 0 ), " " ) )
    OD;
    print( ( newline, newline ) );
    # find where the number 100 first appears                                  #
    BOOL found 100 := FALSE;
    FOR i WHILE NOT found 100 DO
        IF i > UPB sb THEN
            # need more elements                                               #
            sb := STERNBROCOT ( UPB sb * 2 )
        FI;
        IF sb[ i ] = 100 THEN
            print( ( "100 first appears at position ", whole( i, 0 ), newline, newline ) );
            found 100 := TRUE
        FI
    OD;
    # check that the pairs of elements up to 1000 are coprime                  #
    BOOL all coprime := TRUE;
    FOR i FROM 2 TO 1000 WHILE all coprime DO
        all coprime := gcd( sb[ i ], sb[ i - 1 ] ) = 1
    OD;
    print( ( "Element pairs up to 1000 are ", IF all coprime THEN "" ELSE "NOT " FI, "coprime", newline ) )
END
