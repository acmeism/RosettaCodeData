BEGIN # Rice encoding - translation of the Julia sample                       #

    # Golomb-Rice encoding of a positive number to a bit vector               #
    #                                    (string of 0s and 1s) using M of 2^k #
    # dyadic RICEENCODE, allows k to be specified                             #
    PRIO RICEENCODE = 8;
    OP   RICEENCODE = ( INT n, INT k )STRING:
         BEGIN
            IF n < 0 THEN print( ( "cannot encode negative numbers", newline ) ); stop FI;
            INT m = 2 ^ k;
            INT q = n OVER m, r = n MOD m;
            STRING result := "";
            INT v := r;
            WHILE v > 0 DO                 # set result to binary digits of n #
                IF v MOD 2 = 0 THEN "0" ELSE "1" FI +=: result;
                v OVERAB 2
            OD;
            # pad result to k digits                                          #
            FROM ( UPB result - LWB result ) + 2 TO k DO
                "0" +=: result
            OD;
            "0" +=: result;                                 # add a leading 0 #
            TO q DO                                        # and q leading 1s #
                "1" +=: result
            OD;
            result
         END # RICEENCODE # ;
    # monadic RICEENCODE, encodes with k = 2                                  #
    OP   RICEENCODE = ( INT n )STRING: n RICEENCODE 2;

    CO extended encoding of negative numbers
       see wikipedia.org/wiki/Golomb_coding#Use_with_signed_integers
    CO
    PRIO RICEENCODEX = 8;
    OP   RICEENCODEX = ( INT n, INT k )STRING:
         IF INT n2 = 2 * n; n < 0 THEN -n2 - 1 ELSE n2 FI RICEENCODE k;
    OP   RICEENCODEX = ( INT n )STRING: n RICEENCODEX 2;

    # Golomb-Rice decoding of a bit vector (string of 0s and 1s)              #
    #                                                           with M of 2^k #
    PRIO RICEDECODE = 8;
    OP   RICEDECODE = ( STRING a, INT k )INT:
         BEGIN
            INT m = 2 ^ k;
            INT zpos := 0;
            IF NOT char in string( "0", zpos, a ) THEN zpos := LWB a FI;
            INT r := 0;
            FOR z FROM zpos TO UPB a DO
                r *:= 2;
                IF a[ z ] = "1" THEN r +:= 1 FI
            OD;
            INT q = zpos - LWB a;
            q * m + r
         END # RICEDECODE # ;
    OP   RICEDECODE = ( STRING a )INT: a RICEDECODE 2;
    # extended to handle negative numbers                                     #
    PRIO RICEDECODEX = 8;
    OP   RICEDECODEX = ( STRING a, INT k )INT:
             IF   INT i = a RICEDECODE k;
                  ODD i
             THEN - ( ( i + 1 ) OVER 2 )
             ELSE i OVER 2
             FI # RICEDECODEX # ;
    OP   RICEDECODEX = ( STRING a )INT: a RICEDECODEX 2;

    # right pads s with blanks to w characters                                #
    PRIO PAD = 8;
    OP   PAD = ( STRING s, INT w )STRING:
         IF   INT len = ( UPB s - LWB s ) + 1;
              len >= w
         THEN s
         ELSE s + ( ( w - len ) * " " )
         FI # PAD # ;

    print( ( "Base Rice Coding:", newline ) );
    FOR n FROM 0 TO 10 DO
        STRING e = RICEENCODE n;
        print( ( whole( n, -3 ), " -> ", e PAD 10, " -> ", whole( RICEDECODE e, -3 ), newline ) )
    OD;
    print( ( "Extended Rice Coding:", newline ) );
    FOR n FROM -10 TO 10 DO
        STRING e = RICEENCODEX n;
        print( ( whole( n, -3 ), " -> ", e PAD 10, " -> ", whole( RICEDECODEX e, -3 ),  newline ) )
    OD

END
