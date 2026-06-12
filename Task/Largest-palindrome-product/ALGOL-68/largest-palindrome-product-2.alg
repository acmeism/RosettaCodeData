BEGIN # find the highest palindromic multiple of various sizes of numbers #
    PROC is pal = ( LONG INT n )BOOL:
         BEGIN
             STRING x       = whole( n, 0 );
             INT    l      := UPB x + 1;
             BOOL   result := TRUE;
             FOR i FROM LWB x WHILE i < l AND result DO
                 l     -:= 1;
                 result := x[ i ] = x[ l ]
             OD;
             result
          END # is pal # ;

    # maximum 2 digit number #
    LONG INT max := 99;
    # both factors must be >= 10for a 4 digit product #
    LONG INT limit start := 10;
    FOR w FROM 2 TO 7 DO
        LONG INT best prod   := 0;
        # one factor must be divisible by 11 #
        LONG INT limit end = 11 * ( max OVER 11 );
        LONG INT second   := limit start;
        LONG INT first    := 1;
        # loop from hi to low to find the best result in the fewest steps #
        LONG INT n        := limit end + 11;
        WHILE n -:= 11;
              n >= limit start
        DO
            # with n falling, the lower limit of m can rise with #
            # the best-found-so-far second number. Doing this #
            # lowers the iteration count by a lot. #
            LONG INT m := max + 2;
            WHILE m -:= 2;
                  IF   m < second
                  THEN FALSE
                  ELIF LONG INT prod = n * m;
                       best prod > prod
                  THEN FALSE
                  ELIF NOT is pal( prod )
                  THEN TRUE
                  ELSE # maintain the best-found-so-far result #
                       first     := n;
                       second    := m;
                       best prod := prod;
                       TRUE
                  FI
            DO SKIP OD
        OD;
        print( ( "Largest palindromic product of two ", whole( w, 0 )
               , "-digit numbers: ", whole( first, 0 ), " * ", whole( second, 0 )
               , " = ", whole( best prod, 0 )
               , newline
               )
             );
        max *:= 10;
        max +:= 9;
        limit start *:= 10
    OD
END
