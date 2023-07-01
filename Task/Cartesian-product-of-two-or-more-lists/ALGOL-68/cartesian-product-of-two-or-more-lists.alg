BEGIN # Cartesian Product                                                    #
    # Cartesian product operators                                            #
    PRIO X = 7; # give X he same priority as *                               #
    # returns the Cartesian product of the lists a and b                     #
    OP   X = ( []INT a, b )[,]INT:
         BEGIN
            []INT a1  = a[ AT 1 ];
            []INT b1  = b[ AT 1 ];
            INT   len = UPB a1 * UPB b1;
            [ 1 : len, 1 : IF len > 0 THEN 2 ELSE 0 FI ]INT result;
            INT pos := 0;
            FOR i TO UPB a1 DO
                FOR j TO UPB b1 DO
                    pos +:= 1;
                    result[ pos, 1 ] := a1[ i ];
                    result[ pos, 2 ] := b1[ j ]
                OD
            OD;
            result
         END # X # ;
    # returns the Cartesian product of the Cartesian product a and list b    #
    OP   X = ( [,]INT a, []INT b )[,]INT:
         BEGIN
            [,]INT a1   = a[ AT 1, AT 1 ];
            []INT  b1   = b[ AT 1 ];
            INT   len   = 1 UPB a1 * UPB b1;
            INT   width = IF len <= 0 THEN 0 ELSE 2 UPB a1 + 1 FI;
            [ 1 : len, 1 : width  ]INT result;
            INT pos := 0;
            FOR i TO 1 UPB a1 DO
                FOR j TO UPB b1 DO
                    result[ pos +:= 1, 1 : width - 1 ] := a1[ i, : ];
                    result[ pos, width ]               := b1[ j ]
                OD
            OD;
            result
         END # X # ;
    # returns the Cartesian product of the lists in a                        #
    OP   X = ( [][]INT a )[,]INT:
         IF UPB a <= LWB a
         THEN # zero or 1 list                                               #
              [,]INT()
         ELSE # 2 or more lists                                              #
              FLEX[ 1 : 0, 1 : 0 ]INT result := a[ LWB a ] X a[ LWB a + 1 ];
              FOR i FROM LWB a + 2 TO UPB a DO
                  result := result X a[ i ]
              OD;
              result
         FI # X # ;
    # print a Cartesian product                                              #
    PROC print product = ( [,]INT p )VOID:
         BEGIN
            print( ( "[" ) );
            STRING close := "]";
            STRING open  := "(";
            FOR i FROM 1 LWB p TO 1 UPB p DO
                STRING separator := open;
                FOR j FROM 2 LWB p TO 2 UPB p DO
                    print( ( separator, whole( p[ i, j ], 0 ) ) );
                    separator := ","
                OD;
                open  := "),(";
                close := ")]"
            OD;
            print( ( close ) )
         END # print product # ;
    # print a list                                                           #
    PROC print list = ( []INT t )VOID:
         BEGIN
            print( ( "[" ) );
            STRING separator := "";
            FOR i FROM LWB t TO UPB t DO
                print( ( separator, whole( t[ i ], 0 ) ) );
                separator := ","
            OD;
            print( ( "]" ) )
         END # print list # ;
    BEGIN # test the X operators                                             #
        # prints the product of two lists                                    #
        PROC print lxl = ( []INT a, b )VOID:
             BEGIN
                print list( a );print( ( "X" ) );print list( b );
                print( ( "=" ) );print product( a X b );
                print( ( newline ) )
             END # print lxl # ;
        # prints the product of a list of lists                              #
        PROC print xll = ( [][]INT a )VOID:
             IF LWB a < UPB a THEN
                # non empty list of lists                                    #
                print list( a[ LWB a ] );
                FOR i FROM LWB a + 1 TO UPB a DO
                    print( ( "X" ) );print list( a[ i ] )
                OD;
                print( ( "=" ) );print product( X a );
                print( ( newline ) )
             FI # print xll # ;
        print lxl( ( 1, 2 ), ( 3, 4 ) );
        print lxl( ( 3, 4 ), ( 1, 2 ) );
        print lxl( ( 1, 2 ), ()       );
        print lxl( (),       ( 1, 2 ) );
        print xll( ( ( 1776, 1789 ), ( 7, 12 ), ( 4, 14, 23 ), ( 0, 1 ) ) );
        print xll( ( ( 1, 2, 3 ), ( 30 ), ( 500, 100 ) ) );
        print xll( ( ( 1, 2, 3 ), (),     ( 500, 100 ) ) )
    END
END
