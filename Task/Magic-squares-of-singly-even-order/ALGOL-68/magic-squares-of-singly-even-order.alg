BEGIN # construct a magic square of singly even order                        #
      # the singly even magic square procedure is translated from the Java   #
      #                                                               sample #

    CO begin code from the magic squares of odd order task                  CO

    # construct a magic square of odd order                                  #
    PROC odd magic square = ( INT order ) [,]INT:
         IF NOT ODD order OR order < 1 THEN
            # can't make a magic square of the specified order               #
            LOC[ 1 : 0, 1 : 0 ]INT
         ELSE
            # order is OK - construct the square using de la Loubère's       #
            # algorithm as in the wikipedia page                             #

            [ 1 : order, 1 : order ]INT square;
            FOR i TO order DO FOR j TO order DO square[ i, j ] := 0 OD OD;

            # operator to advance "up" the square                            #
            OP   PREV = ( INT pos )INT: IF pos = 1 THEN order ELSE pos - 1 FI;
            # operator to advance "across right" or "down" the square        #
            OP   NEXT = ( INT pos )INT: ( pos MOD order ) + 1;

            # fill in the square, starting from the middle of the top row    #
            INT col := ( order + 1 ) OVER 2;
            INT row := 1;
            FOR i TO order * order DO
                square[ row, col ] := i;
                IF square[ PREV row, NEXT col ] /= 0 THEN
                    # the up/right position is already taken, move down      #
                    row := NEXT row
                ELSE
                    # can move up and right                                  #
                    row := PREV row;
                    col := NEXT col
                FI
            OD;

            square
         FI # odd magic square # ;

    PROC print square = ( [,]INT square )VOID: # prints the magic square     #
         BEGIN

            INT order = 1 UPB square;

            # calculate print width: negative so leading "+"s aren't printed #
            INT width := -1;
            INT mag   := order * order;
            WHILE mag >= 10 DO mag OVERAB 10; width -:= 1 OD;

            # calculate the "magic sum"                                      #
            INT sum := 0;
            FOR i TO order DO sum +:= square[ 1, i ] OD;

            # print the square                                               #
            print( ( "maqic square of order ", whole( order, 0 ) ) );
            print( ( ": sum: ", whole( sum, 0 ), newline ) );
            FOR i TO order DO
                FOR j TO order DO write( ( " ", whole( square[ i, j ], width ) ) ) OD;
                print( ( newline ) )
            OD

         END # print square # ;

    CO end   code from the magic squares of odd order task                  CO

    # returns a magic square of singly even order n                          #
    PROC singly even magic square = ( INT n )[,]INT:
         IF n < 6 OR ( n - 2 ) MOD 4 /= 0 THEN
            LOC[ 1 : 0, 1 : 0 ]INT # n is not 2 + a multiple of 4 >= 6       #
         ELSE
            # order is OK                                                    #
            INT size = n * n;
            INT half n = n OVER 2;
            INT sub square size = size OVER 4;

            [,]INT sub square = odd magic square( half n )[ AT 0, AT 0 ];
            []INT quadrant factors = []INT( 0, 2, 3, 1 )[ AT 0 ];
            [ 0 : n - 1, 0 : n - 1 ]INT result;

            FOR r FROM 1 LWB result TO 1 UPB result DO
                FOR c FROM 2 LWB result TO 2 UPB result DO
                    INT quadrant = ( r OVER half n ) * 2 + ( c OVER half n );
                    result[ r, c ] := sub square[ r MOD half n, c MOD half n ]
                                    + quadrant factors[ quadrant ] * sub square size
                OD
            OD;

            INT n cols left  = half n OVER 2;
            INT n cols right = n cols left - 1;

            FOR r FROM 1 LWB result TO half n - 1 DO
                FOR c FROM 1 LWB result TO 1 UPB result DO
                    IF c < n cols left OR c >= n - n cols right
                    OR ( c = n cols left AND r = n cols left )
                    THEN
                        IF c /= 0 OR r /= n cols left THEN
                            INT tmp                  = result[ r, c ];
                            result[ r,          c ] := result[ r + half n, c ];
                            result[ r + half n, c ] := tmp
                        FI
                    FI
                OD
            OD;

            result[ AT 1, AT 1 ]
         FI # singly even magic square # ;

    print square( singly even magic square( 6 ) )

END
