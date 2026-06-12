BEGIN # find some Ulam numbers, U(n) = the smallest number > U(n-1) that is  #
      # the uniue sum of U(i) and U(j), i, j < n, i =/= j, U(1)=1, U(2) = 2  #
    INT max ulam  = 10 000;                    # maximum ulam number to find #
    [ 1 : max ulam ]INT u;                              # ulam numbers found #
    FOR i TO UPB u DO u[ i ] := 0 OD;
    INT ulam size = 20 000;         # initial size of the ulam number buffer #
    CHAR unused = "0", one = "1", multiple = "2";   # states of ulam numbers #
    FLEX[ 1 : ulam size ]CHAR ulam;FOR i TO UPB ulam DO ulam[ i ] := unused OD;
    ulam[ 3 ] := ulam[ 2 ] := ulam[ 1 ] := one; u[ 1 ] := 1; u[ 2 ] := 2;
    print( ( " 1 2" ) );
    INT u count      :=   2;                  # numer of ulam numbers found  #
    INT power of ten := 100;       # next "power of ten" ulam number to show #
    FOR i FROM 3 WHILE u count < max ulam DO
        IF ulam[ i ] = one THEN
            # can use this number                                            #
            u[ u count +:= 1 ] := i;
            IF u count < 21 THEN
                print( ( " ", whole( i, 0 ) ) );
                IF u count = 20 THEN print( ( "..." ) ) FI
            ELIF u count = power of ten THEN
                print( ( newline, "The ", whole( power of ten, -6 ) ) );
                print( ( "th Ulam number is: ", whole( i, 0 ) ) );
                power of ten *:= 10
            FI;
            FOR p TO u count - 1 DO
                INT upi = u[ p ] + i;
                IF upi > UPB ulam THEN
                    # need a bigger ulam buffer                              #
                    [ 1 : UPB ulam + ulam size ]CHAR new ulam;
                    new ulam[ 1 : UPB ulam ] := ulam;
                    FOR u pos FROM UPB ulam + 1 TO UPB new ulam DO new ulam[ u pos ] := unused OD;
                    ulam := new ulam
                FI;
                CHAR upic = ulam[ upi ];
                IF   upic = unused
                THEN ulam[ upi ] := one         # u[ p ] + i is unique so far #
                ELIF upic = one
                THEN ulam[ upi ] := multiple    # u[ p ] + i isn't unique     #
                FI
            OD
        FI
    OD;
    print( ( newline ) )
END
