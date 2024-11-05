# operator to return the sum of the digits of an integer value in the #
# specified base                                                      #
PRIO SUMDIGITS = 1;
OP   SUMDIGITS = ( INT value, INT base )INT:
     IF base < 2
     THEN
         # invalid base #
         print( ( "Base for digit sum must be at least 2", newline ) );
         stop
     ELSE
         # the base is OK #
         INT    result := 0;
         INT    rest   := ABS value;

         WHILE rest /= 0
         DO
             result PLUSAB ( rest MOD base );
             rest   OVERAB base
         OD;

         result
     FI; # SUMDIGITS #

# additional operator so we can sum the digits of values expressed in #
# other than base 10, e.g. 16ra is a hex lteral with value 10         #
# (Algol 68 allows bases 2, 4, 8 and 16 for non-base 10 literals)     #
# however as such literals are BITS values, not INTs, we need this    #
# second operator                                                     #
OP   SUMDIGITS = ( BITS value, INT base )INT: ABS value SUMDIGITS base;

BEGIN # test the SUMDIGITS operator #

    print( ( "value\base base digit-sum", newline ) );
    print( ( "      1\10   10 ", whole(      1 SUMDIGITS 10, -9 ), newline ) );
    print( ( "   1234\10   10 ", whole(   1234 SUMDIGITS 10, -9 ), newline ) );
    print( ( "     fe\16   16 ", whole(  16rfe SUMDIGITS 16, -9 ), newline ) );
    print( ( "    f0e\16   16 ", whole( 16rf0e SUMDIGITS 16, -9 ), newline ) );

    # of course, we don't have to express the number in the base we sum #
    # the digits in...                                                  #
    print( ( "     73\10   71 ", whole(     73 SUMDIGITS 71, -9 ), newline ) )

END
