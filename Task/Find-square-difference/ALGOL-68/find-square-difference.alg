BEGIN # find the lowest positive n where the difference between n^2 and (n-1)^2 is > 1000 #
    # shows the smalled square n where n^2 - (n-1)^2 is greater than required difference  #
    #       n^2 - ( n - 1 )^2 is n^2 - n^2 + 2n - 1, i.e. 2n - 1                          #
    #       so 2n - 1 > required difference or n > ( required difference + 1 ) / 2        #
    PROC show least square = ( INT required difference )VOID:
        print( ( "Smallest n where n^2 - (n-1)^2 is > ", whole( required difference, -12 )
               , " is: ", whole( ( ( required difference + 1 ) OVER 2 ) + 1, -12 )
               , newline
               )
             );
    show least square(         1 000 );
    show least square(        32 000 );
    show least square( 2 000 000 000 )
END
