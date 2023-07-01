# find values of p( L, n ) where p( L, n ) is the nth-smallest j such that          #
#      the decimal representation of 2^j starts with the digits of L                #
BEGIN
    # returns a string representation of n with commas                              #
    PROC commatise = ( LONG INT n )STRING:
         BEGIN
            STRING result      := "";
            STRING unformatted  = whole( n, 0 );
            INT    ch count    := 0;
            FOR c FROM UPB unformatted BY -1 TO LWB unformatted DO
                IF   ch count <= 2 THEN ch count +:= 1
                ELSE                    ch count  := 1; "," +=: result
                FI;
                unformatted[ c ] +=: result
            OD;
            result
         END # commatise # ;
    # returns p( prefix, occurance )                                                 #
    PROC p = ( INT prefix, INT occurance )LONG INT:
    BEGIN
        LONG INT quarter long max int = long max int OVER 4;
        LONG INT p2                  := 1;
        INT      count               := 0;
        INT      power               := 0;
        WHILE count < occurance DO
            power       +:= 1;
            p2          +:= p2;
            LONG INT pre := p2;
            WHILE pre > prefix DO
                pre OVERAB 10
            OD;
            IF pre = prefix THEN
                count +:= 1
            FI;
            IF p2 > quarter long max int THEN
                p2 OVERAB 10 000
            FI
        OD;
        power
    END # p # ;
    # prints p( prefix, occurance )                                                 #
    PROC print p = ( INT prefix, INT occurance )VOID:
        print( ( "p(", whole( prefix, 0 ), ", ", whole( occurance, 0 ), ") = ", commatise( p( prefix, occurance ) ), newline ) );
    # task test cases                                                               #
    print p(  12,      1 );
    print p(  12,      2 );
    print p( 123,     45 );
    print p( 123,  12345 );
    print p( 123, 678910 )
END
