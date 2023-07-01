# generates a string of random opening and closing brackets. The number of    #
# each type of brackets is speccified in length                               #
PROC get brackets = ( INT length ) STRING:
    BEGIN
        INT   result length = length * 2;
        [ 1 : result length ]CHAR result;
        # initialise the brackets to all open brackets                        #
        FOR char pos TO result length DO result[ char pos ] := "[" OD;
        # set half of the brackets to close brackets                          #
        INT   close count := 0;
        WHILE close count < length
        DO
            INT   random pos = 1 + ENTIER ( next random * result length );
            IF result[ random pos ] = "["
            THEN
                close count          +:= 1;
                result[ random pos ]  := "]"
            FI
        OD;
        result
    END # get brackets # ;

# returns TRUE if the brackets string contains a correctly nested sequence    #
# of brackets, FALSE otherwise                                                #
PROC check brackets = ( STRING brackets ) BOOL:
    BEGIN
        INT depth := 0;
        FOR char pos FROM LWB brackets TO UPB brackets
        WHILE
            IF brackets[ char pos ] = "["
            THEN
                depth +:= 1
            ELSE
                depth -:= 1
            FI;
            depth >= 0
        DO
            SKIP
        OD;
        # depth will be 0 if we reached the end of the string and it was     #
        # correct, non-0 otherwise                                           #
        depth = 0
    END # check brackets # ;

# procedure to test check brackets                                           #
PROC test check brackets = ( STRING brackets ) VOID:
    print( ( ( brackets
             + ": "
             + IF check brackets( brackets ) THEN "ok" ELSE "not ok" FI
             )
           , newline
           )
         ) ;

# test the bracket generation and checking PROCs                             #
test check brackets( get brackets( 0 ) );
FOR length TO 12
DO
    TO 2
    DO
        test check brackets( get brackets( length ) )
    OD
OD
