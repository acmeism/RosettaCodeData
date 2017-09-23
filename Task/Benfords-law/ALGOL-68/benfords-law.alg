BEGIN
    # set the number of digits for LONG LONG INT values #
    PR precision 256 PR
    # returns the probability of the first digit of each non-zero number in s #
    PROC digit probability = ( []LONG LONG INT s )[]REAL:
         BEGIN
            [ 1 : 9 ]REAL result;
            # count the number of times each digit is the first #
            [ 1 : 9 ]INT  count := ( 0, 0, 0, 0, 0, 0, 0, 0, 0 );
            FOR i FROM LWB s TO UPB s DO
                LONG LONG INT v := ABS s[ i ];
                IF v /= 0 THEN
                    WHILE v > 9 DO v OVERAB 10 OD;
                    count[ SHORTEN SHORTEN v ] +:= 1
                FI
            OD;
            # calculate the probability of each digit #
            INT number of elements = ( UPB s + 1 ) - LWB s;
            FOR i TO 9 DO
                result[ i ] := IF number of elements = 0 THEN 0 ELSE count[ i ] / number of elements FI
            OD;
            result
         END # digit probability # ;
    # outputs the digit probabilities of some numbers and those expected by Benford's law #
    PROC compare to benford = ( []REAL actual )VOID:
         FOR i TO 9 DO
            print( ( "Benford: ", fixed( log( 1 + ( 1 / i ) ), -7, 3 ), " actual: ", fixed( actual[ i ], -7, 3 ), newline ) )
         OD # compare to benford # ;
    # generate 1000 fibonacci numbers #
    [ 0 : 1000 ]LONG LONG INT fn;
    fn[ 0 ] := 0;
    fn[ 1 ] := 1;
    FOR i FROM 2 TO UPB fn DO fn[ i ] := fn[ i - 1 ] + fn[ i - 2 ] OD;
    # get the probabilities of each first digit of the fibonacci numbers and #
    # compare to the probabilities expected by Benford's law #
    compare to benford( digit probability( fn ) )
END
