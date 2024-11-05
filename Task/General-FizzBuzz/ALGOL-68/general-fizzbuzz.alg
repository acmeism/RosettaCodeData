BEGIN # generalised FizzBuzz                                        #
    # prompts for an integer, reads it and returns it               #
    PROC read an integer = ( STRING prompt )INT:
         BEGIN
            print( ( prompt ) );
            INT result;
            read( ( result, newline ) );
            result
         END; # read an integer #
    # prompts for a string, reads it and returns it                 #
    PROC read a string = ( STRING prompt )STRING:
         BEGIN
            print( ( prompt ) );
            STRING result;
            read( ( result, newline ) );
            result
         END; # read a string #
    # mode to hold a factor and associated text                     #
    MODE FBFACTOR = STRUCT( INT factor, STRING text );
    #===============================================================#
    # quicksort routine for the factors                             #
    # - from the Algol 68 task sample                               #
    #---------------------------------------------------------------#
    #--- Swap function ---#
    PROC swap = (REF[]FBFACTOR array, INT first, INT second) VOID:
    (   FBFACTOR temp  = array[first];
        array[first]  := array[second];
        array[second] := temp
    );
    #--- Quick sort 3 arg function ---#
    PROC quick = (REF[]FBFACTOR array, INT first, INT last) VOID:
    (   INT       smaller := first + 1, larger  := last;
        FBFACTOR  pivot   := array[first];
        WHILE smaller <= larger DO
            WHILE array[smaller] < pivot AND smaller < last  DO smaller +:= 1 OD;
            WHILE array[larger]  > pivot AND larger  > first DO larger  -:= 1 OD;
            IF smaller < larger THEN
                swap(array, smaller, larger);
                smaller +:= 1;
                larger  -:= 1
            ELSE
                smaller +:= 1
            FI
        OD;
        swap(array, first, larger);
        IF first < larger -1 THEN quick(array, first, larger-1) FI;
        IF last  > larger +1 THEN quick(array, larger+1, last)  FI
    );
    # comparison operators #
    OP < = ( FBFACTOR a, b )BOOL: factor OF a < factor OF b;
    OP > = ( FBFACTOR a, b )BOOL: factor OF a > factor OF b;
    #===============================================================#
    # get the maximum number to consider                            #
    INT max number = read an integer( "Numbers required: " );
    # number of factors required                                    #
    INT max factor = 3;
    # get the factors and associated words                          #
    [ max factor ]FBFACTOR factors;
    FOR i TO max factor DO
        factor OF factors[ i ] := read an integer( "Factor " + whole( i, 0 ) + ": " );
        text OF factors  [ i ] := read a string( "Text for " + whole( factor OF factors[ i ], 0 ) + ": " )
    OD;
    # sort the factors into order                                   #
    quick( factors, 1, UPB factors );
    # play the game                                                 #
    FOR n TO max number DO
        STRING text := "";
        FOR factor TO max factor DO
            IF n MOD factor OF factors[ factor ] = 0 THEN text +:= text OF factors[ factor ] FI
        OD;
        IF text = "" THEN
            # no words applicable to n, just show the digits        #
            text := whole( n, 0 )
        FI;
        print( ( text, newline ) )
    OD
END
