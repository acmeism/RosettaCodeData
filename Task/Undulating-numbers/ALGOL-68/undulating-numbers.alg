BEGIN # show some Undulating numbers - numbers whose digits form the pattern #
      #                                ABAB...                               #

    LONG INT max number = LONG 2 ^ 53;     # maximum number we will consider #
    STRING   max name   = "2^53";          # "name" of max number            #
    # returns TRUE if n is prime, FALSE otherwise - uses trial division      #
    PROC is prime = ( LONG INT n )BOOL:
         IF   n < 3       THEN n = 2
         ELIF n MOD 3 = 0 THEN n = 3
         ELIF NOT ODD n   THEN FALSE
         ELSE
             BOOL is a prime := TRUE;
             INT  f          := 5;
             INT  f2         := 25;
             INT  to next    := 24;
             WHILE f2 <= n AND is a prime DO
                 is a prime := n MOD f /= 0;
                 f         +:= 2;
                 f2        +:= to next;
                 to next   +:= 8
             OD;
             is a prime
         FI # is prime # ;
    # returns s with comma separators                                        #
    PROC commatise = ( STRING s )STRING:
         BEGIN
            STRING result := "";
            INT r pos     := -1;
            FOR s pos FROM UPB s BY -1 TO LWB s DO
                IF ( r pos +:= 1 ) = 3 THEN
                    r pos := 0;
                    "," +=: result
                FI;
                s[ s pos ] +=: result
            OD;
            result
         END # commatise # ;
    # returns a string representation of the undulating number in base b     #
    #         with first digit f and second digit s with d digits in total   #
    PROC undulating string = ( INT d, f, s, b )STRING:
         BEGIN
            STRING un    := "";
            CHAR   fc     = REPR ( f + ABS "0" );
            CHAR   sc     = REPR ( s + ABS "0" );
            FOR digit FROM d BY -1 TO 1 DO
                IF ODD digit THEN fc ELSE sc FI +=: un
            OD;
            commatise( un )
         END # undulating string # ;
    # shows various Undulating numbers in base b                             #
    PROC print undulation = ( INT b )VOID:
         BEGIN
            LONG INT un          := 0;
            INT      un count    := 0;
            INT      p count     := 0;
            INT      last d      := 0;
            INT      last f      := 0;
            INT      last s      := 0;
            LONG INT last un     := 0;
            [ 1 : ( b - 1 ) * ( b - 1 ) ]LONG INT prime un;
            FOR digits FROM 3 WHILE un < max number DO
                IF digits = 3 OR digits = 4 THEN
                    print( ( whole( digits, 0 ), " digit Undulating Numbers in base " ) );
                    print( ( whole( b, 0 ) ) );
                    IF b /= 10 THEN print( ( " (shown in base 10)" ) ) FI;
                    print( ( ":", newline ) )
                FI;
                FOR f TO b - 1 WHILE  un < max number DO
                    FOR s FROM 0 TO b - 1 WHILE  un < max number DO
                        IF f /= s THEN
                            un        := 0;
                            FOR d TO digits DO
                                un *:= b
                                   +:= IF ODD d THEN f ELSE s FI
                            OD;
                            IF un < max number THEN
                                un count +:= 1;
                                last un   := un;
                                last d    := digits;
                                last f    := f;
                                last s    := s;
                                IF digits = 3 OR digits = 4 THEN
                                    print( ( " ", whole( un, -digits ) ) );
                                    IF digits = 3 THEN
                                        IF is prime( un ) THEN
                                            prime un[ p count +:= 1 ] := un
                                        FI
                                    FI
                                ELIF un count = 600 THEN
                                   print( ( "Undulating number 600 in base ", whole( b, 0 ), ": " ) );
                                   print( ( undulating string( digits, f, s, b ) ) );
                                   IF b /= 10 THEN
                                       print( ( newline, "        which is: " ) );
                                       print( ( commatise( whole( un, 0 ) ) ) );
                                       print( ( " in base 10", newline ) )
                                   FI;
                                   print( ( newline ) )
                                FI
                            FI
                        FI
                    OD;
                    IF digits = 3 OR digits = 4 THEN print( ( newline ) ) FI
                OD;
                IF digits = 3 OR digits = 4 THEN
                    print( ( newline ) );
                    IF digits = 4 THEN
                        print( ( "Prime 3 digit Undulating Numbers in base " ) );
                        print( ( whole( b, 0 ) ) );
                        IF b /= 10 THEN print( ( " (shown in base 10)" ) ) FI;
                        print( ( ":", newline ) );
                        FOR i TO p count DO
                            print( ( whole( prime un[ i ], -4 ) ) );
                            IF i MOD b = ( b - 1 ) THEN print( ( newline ) ) FI
                        OD;
                        IF p count MOD b /= ( b - 1 ) THEN print( ( newline ) ) FI;
                        print( ( newline ) )
                    FI
                FI
            OD;
            print( ( "There are ", whole( un count, 0 ) ) );
            print( ( " Undulating nnumbers in base ", whole( b, 0 ), " before ", max name, newline ) );
            print( ( "The last is: ", undulating string( last d, last f, last s, b ), newline ) );
            IF b /= 10 THEN
                print( ( "   which is: ", commatise( whole( last un, 0 ) ), " in base 10", newline ) )
            FI
         END # print undulation # ;

    print undulation( 10 ); # base 10 undulating numbers                #
    print( ( newline ) );
    print undulation(  7 )  # base  7 undulating numbers                #

END
