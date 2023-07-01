BEGIN
    PRIO SCS = 1;
    # returns the shortest common supersequence of x and y #
    OP   SCS = ( STRING x, y )STRING:
         IF   x = "" THEN y
         ELIF y = "" THEN x
         ELIF x[ LWB x ] = y[ LWB y ]
         THEN x[ LWB x ] + ( x[ LWB x + 1 : ] SCS y[ LWB y + 1 : ] )
         ELIF STRING x y sub = x SCS y[ LWB y + 1 : ];
              STRING x sub y = x[ LWB x + 1 : ] SCS y;
              INT x y sub size = ( UPB x y sub - LWB x y sub ) + 1;
              INT x sub y size = ( UPB x sub y - LWB x sub y ) + 1;
              x y sub size <= x sub y size
         THEN y[ LWB y ] + x y sub
         ELSE x[ LWB x ] + x sub y
         FI # SCS # ;

    print( ( "abcbdab" SCS "bdcaba", newline ) )
END
