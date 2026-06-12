BEGIN # decode posit format numbers - translated from the FreeBASIC sample #

    # returns a formatted representation of v#
    OP   TOSTRING = ( LONG REAL v )STRING:
         BEGIN
            STRING result := IF v > -100 000 AND v < 100 000 AND ABS v >= 0.1
                             THEN fixed( v, -14, 12 )
                             ELSE float( v, -22, 15, 4 )
                             FI;
            IF   result[ LWB result ] = "."
            THEN "0" +=: result
            ELIF result[ LWB result : LWB result + 1 ] = "-."
            THEN result := "-0" + result[ LWB result + 2 : ]
            FI;
            IF NOT char in string( "e", NIL, result ) THEN
               WHILE result[ UPB result ] = "0" DO result := result[ LWB result : UPB result - 1 ] OD;
               IF result[ UPB result ] = "." THEN  result := result[ LWB result : UPB result - 1 ] FI
            FI;
            result
         END # TOSTRING # ;
    # returns the length of s #
    OP   LENGTH = ( STRING s )INT: ( UPB s - LWB s ) + 1;
    # returns v in converted to a binary digit string of width w #
    PRIO TOBITSTRING = 9;
    OP   TOBITSTRING = ( INT v in, w )STRING:
         BEGIN
            STRING result := "";
            INT    v      := v in;
            WHILE v > 0 DO IF ODD v THEN "1" ELSE "0" FI +=: result; v OVERAB 2 OD;
            IF LENGTH result < w THEN ( "0" * ( w - LENGTH result ) ) +=: result FI;
            result
         END # TOBITSTRING # ;
    # returns s converted to an INT, assuming s is a valid binary number #
    OP   FROMBITSTRING = ( STRING s )INT:
         BEGIN
            INT result := 0;
            FOR pos FROM LWB s TO UPB s DO
                result *:= 2;
                IF s[ pos ] = "1" THEN result +:= 1 FI
            OD;
            result
         END # FROMBITSTRING # ;

    # TASK #

    PROC min = ( INT a, b )INT: IF a < b THEN a ELSE b FI;

    PROC twos compliment = ( STRING sbits, INT nbits )STRING:
         BEGIN
            STRING result := sbits[ @ 1 ];
            FOR i TO nbits DO
                result[ i ] := IF result[ i ] = "0" THEN "1" ELSE "0" FI
            OD;
            BOOL found0 := FALSE;
            FOR i FROM nbits BY - 1 TO 1 WHILE NOT found0 DO
                IF found0 := result[ i ] = "0"
                THEN result[ i ] := "1"
                ELSE result[ i ] := "0"
                FI
            OD;
            result
         END # twos compliment # ;

    PROC posit decode = ( INT nbits, es, bits in )STRING:
         IF STRING sbits := bits in TOBITSTRING nbits;
            STRING ibits  = sbits;
            LENGTH ibits /= nbits
         THEN
            print( ( "Length of """, ibits, """ is not ", whole( nbits, 0 ), newline ) );
            stop
         ELSE
            STRING result := "";
            BOOL s = sbits[ 1 ] = "1";
            IF s THEN sbits[ 2 : ] := twos compliment( sbits[ 2 : ], nbits - 1 ) FI;
            BOOL b2z = sbits[ 2 ] = "0";
            INT  r  := 0;
            IF NOT char in string( IF b2z THEN "1" ELSE "0" FI, r, sbits[ 3 : ] ) THEN r := -2 FI;
            LONG REAL fs    := 1;
            LONG REAL useed  = 2.0 ^ ( 2 ^ es );
            INT  exponent   := 0;
            INT  fraction   := 0;
            IF r < 0 THEN
                IF b2z THEN
                    result := IF s THEN """NaR""" ELSE """zero""" FI
                FI;
                r := nbits - 1
            ELSE
                INT estart  = r + 3;
                INT efinish = min( r + 2 + es, nbits );
                exponent   := FROMBITSTRING sbits[ estart : efinish ];
                fraction   := FROMBITSTRING sbits[ efinish + 1 : ];
                fs         := 2.0 ^ ( nbits - efinish )
            FI;
            IF result = "" THEN
                INT  k  = IF b2z THEN -r ELSE r - 1 FI;
                result :=
                    TOSTRING ( IF s THEN -1 ELSE 1 FI * useed ^ k * 2 ^ exponent * ( 1 + fraction / fs ) )
            FI;
            ibits + " (es=" + whole( es, 0 ) + ") ==> " + result
         FI # positDecode # ;

    [,]INT tests = ( ( 16, 3, ABS 2r0000110111011101 ), ( 16, 3, ABS 2r1000000000000000 )
                   , ( 16, 3, ABS 2r0000000000000000 ), ( 16, 1, ABS 2r0110110010101000 )
                   , ( 16, 1, ABS 2r1001001101011000 ), ( 16, 2, ABS 2r0000000000000001 )
                   , ( 16, 0, ABS 2r0111111111111111 ), ( 16, 2, ABS 2r0111111111111111 )
                   , ( 16, 6, ABS 2r0111111111111110 )
                   , (  8, 1, ABS 2r01000000 ), ( 8, 1, ABS 2r11000000 ), ( 8, 1, ABS 2r00110000 )
                   , (  8, 1, ABS 2r00100000 ), ( 8, 2, ABS 2r00000001 ), ( 8, 2, ABS 2r01111111 )
                   , (  8, 7, ABS 2r01111110 )
                   , ( 32, 2, ABS 2r00000000000000000000000000000001 )
                   , ( 32, 2, ABS 2r01111111111111111111111111111111 )
                   , ( 32, 5, ABS 2r01111111111111111111111111111110 )
                   );
    FOR i FROM LWB tests TO UPB tests DO
        print( ( posit decode( tests[ i, 1 ], tests[ i, 2 ], tests[ i, 3 ] ), newline ) )
    OD
END
