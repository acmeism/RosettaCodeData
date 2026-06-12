BEGIN # count magic numbers: numbers divisible by the count of digits and    #
      # each left substring is also divisible by the count of its digits     #
    # returns the magic numbers of length m length that can be formed by      #
    # adding a digit to the elements of prev m                               #
    PROC next magic = ( []LONG LONG INT prev m, INT m length )[]LONG LONG INT:
         BEGIN
            FLEX[ 1 : 2 000 ]LONG LONG INT m;
            INT m pos := 0;
            FOR i FROM LWB prev m TO UPB prev m DO
                LONG LONG INT n := prev m[ i ] * 10;
                FOR d FROM 0 BY IF ODD m length THEN 1 ELSE 2 FI TO 9 DO
                    IF ( n + d ) MOD m length = 0 THEN
                        IF m pos >= UPB m THEN
                            # need a bigger magic number buffer              #
                            [ 1 : UPB m + 1000 ]LONG LONG INT new m;
                            new m[ 1 : UPB m ] := m;
                            m                  := new m
                        FI;
                        m[ m pos +:= 1 ] := n + d
                    FI
                OD
            OD;
            m[ 1 : m pos ]
         END # next magic # ;
    # returns TRUE if n is pandigital (1-9), FALSE otherwise                 #
    PROC is pandigital1 = ( LONG LONG INT n )BOOL:
         BEGIN
            INT v := SHORTEN SHORTEN n;
            [ 0 : 9 ]INT digit count := []INT( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 )[ AT 0 ];
            WHILE digit count[ v MOD 10 ] +:= 1;
                  ( v OVERAB 10 ) > 0
            DO SKIP OD;
            BOOL result := digit count[ 0 ] = 0;
            FOR i FROM 1 TO 9 WHILE result := digit count[ i ] = 1 DO SKIP OD;
            result
         END # is pandigital1 # ;
    # find the magic numbers                                                 #
    print( ( "Magic number counts by number of digits:", newline ) );
    INT m count := 0;                        # total number of magic numbers #
    INT d count := 1;                                     # number of digits #
    FLEX[ 1 : 10 ]LONG LONG INT magic := ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 );
    FLEX[ 1 :  0 ]LONG LONG INT magic9;
    LONG LONG INT max magic := -1;
    WHILE UPB magic >= LWB magic DO
        print( ( whole( d count, -5 ), ": ", whole( UPB magic, -9 ), newline ) );
        m count  +:= UPB magic;
        max magic := magic[ UPB magic ];
        IF   d count = 1 THEN
            # exclude 0 from the 1 digit magic numbers to find the 2 digit   #
            magic := ( 1, 2, 3, 4, 5, 6, 7, 8, 9 )
        ELIF d count = 9 THEN
            # save the 9 digit magic numbers so we can find the pandigitals  #
            magic9 := magic
        FI;
        magic := next magic( magic, d count +:= 1 )
    OD;
    print( ( "Total:", whole( m count, -10 ), " magic numbers", newline ) );
    print( ( "Largest is ", whole( max magic, 0 ), newline ) );
    # find the minimally pandigital magic numbers                            #
    [ 1 : UPB magic9 ]LONG LONG INT pd magic;
    INT pd pos := 0;
    FOR i FROM LWB pd magic TO UPB pd magic DO
        IF is pandigital1( magic9[ i ] ) THEN
            pd magic[ pd pos +:= 1 ] := magic9[ i ]
        FI
    OD;
    print( ( "Minimally pandigital 1-9 magic numbers: " ) );
    FOR i TO pd pos DO
        print( ( whole( pd magic[ i ], 0 ) ) )
    OD;
    print( ( newline ) );
    print( ( "Minimally pandigital 0-9 magic numbers: " ) );
    FOR i TO pd pos DO
        print( ( whole( pd magic[ i ] * 10, 0 ) ) )
    OD;
    print( ( newline ) )
END
