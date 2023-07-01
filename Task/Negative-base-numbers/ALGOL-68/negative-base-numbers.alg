# Conversion to/from negative base numbers                                    #
# Note - no checks for valid bases or digits bases -2 .. -63 are handled      #
#        A-Z represent the digits 11 .. 35, a-z represent the digits 36 .. 61 #
#        the digit 62 is represented by a space                               #

#                               1         2         3         4         5         6          #
#                               01234567890123456789012345678901234567890123456789012        #
[]CHAR base digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "[ AT 0 ];

# returns s decoded to an integer from the negative base b                   #
PRIO FROMNBASE = 9;
OP   FROMNBASE = ( STRING s, INT b )LONG INT:
     BEGIN
        LONG INT    result          := 0;
        LONG INT    base multiplier := 1;
        FOR d pos FROM UPB s BY -1 TO LWB s DO
            INT digit = IF   s[ d pos ] = " "
                        THEN 62
                        ELIF s[ d pos ] >= "a"
                        THEN ( ABS s[ d pos ] + 36 ) - ABS "a"
                        ELIF s[ d pos ] >= "A"
                        THEN ( ABS s[ d pos ] + 10 ) - ABS "A"
                        ELSE ABS s[ d pos ] - ABS "0"
                        FI;
            result          +:= base multiplier * digit;
            base multiplier *:= b
        OD;
        result
     END # FROMNBASE # ;
OP   FROMNBASE = ( CHAR c, INT b )LONG INT: STRING(c) FROMNBASE b;

# returns n encoded as a string in the negative base b #
PRIO TONBASE = 9;
OP   TONBASE = ( LONG INT n, INT b )STRING:
     BEGIN
        STRING   result := "";
        LONG INT v      := n;
        WHILE
            INT d := SHORTEN IF v < 0 THEN - ( ABS v MOD b ) ELSE v MOD b FI;
            v OVERAB b;
            IF d < 0
            THEN
                d -:= b;
                v +:= 1
            FI;
            base digits[ d ] +=: result;
            v /= 0
        DO SKIP OD;
        result
     END # TONBASE # ;

# tests the TONBASE and FROMNBASE operators #
PROC test n base = ( LONG INT number, INT base, STRING expected )VOID:
     BEGIN
        PROC expect = ( BOOL result )STRING: IF result THEN "" ELSE " INCORRECT" FI;
        STRING   encoded = number  TONBASE   base;
        LONG INT decoded = encoded FROMNBASE base;
        print( ( whole( number, 0 ), " encodes to: ", encoded ) );
        print( ( " base ", whole( base, 0 ), expect( encoded = expected ), newline ) );
        print( ( encoded, " decodes to: ", whole( decoded, 0 ) ) );
        print( ( " base ", whole( base, 0 ), expect( decoded = number   ), newline ) )
     END # test n base # ;

test n base(                    10,  -2,    "11110" );
test n base(                   146,  -3,    "21102" );
test n base(                    15, -10,      "195" );
# The defining document for ALGOL 68 spells the name "Algol 68" on the cover, though inside it is "ALGOL 68" #
# at the risk of "judging a language by it's cover", we use "Algol 68" as the name here...                   #
test n base( - LONG 36492107981104, -63, "Algol 68" )
