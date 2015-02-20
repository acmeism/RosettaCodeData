# calculate the shannon entropy of a string                                #

PROC shannon entropy = ( STRING s )REAL:
    BEGIN

        INT string length = ( UPB s - LWB s ) + 1;

        # count the occurances of each character #

        [ 0 : max abs char ]INT char count;

        FOR char pos FROM LWB char count TO UPB char count DO
            char count[ char pos ] := 0
        OD;

        FOR char pos FROM LWB s TO UPB s DO
            char count[ ABS s[ char pos ] ] +:= 1
        OD;

        # calculate the entropy, we use log base 10 and then convert #
        # to log base 2 after calculating the sum                    #

        REAL entropy := 0;

        FOR char pos FROM LWB char count TO UPB char count DO
            IF char count[ char pos ] /= 0
            THEN
                # have a character that occurs in the string #
                REAL probability = char count[ char pos ] / string length;
                entropy -:= probability * log( probability )
            FI
        OD;

        entropy / log( 2 )
    END; # shannon entropy #



main:
(
    # test the shannon entropy routine #
    print( ( shannon entropy( "1223334444" ), newline ) )
)
