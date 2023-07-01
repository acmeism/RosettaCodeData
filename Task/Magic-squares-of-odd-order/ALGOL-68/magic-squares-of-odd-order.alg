# construct a magic square of odd order                                      #
PROC magic square = ( INT order ) [,]INT:
    IF NOT ODD order OR order < 1
    THEN
        # can't make a magic square of the specified order                   #
        LOC [ 1 : 0, 1 : 0 ]INT
    ELSE
        # order is OK - construct the square using de la Loubère's           #
        # algorithm as in the wikipedia page                                 #

        [ 1 : order, 1 : order ]INT square;
        FOR i TO order DO FOR j TO order DO square[ i, j ] := 0 OD OD;

        # as square [ 1, 1 ] if the top-left, moving "up" reduces the row    #
        # operator to advance "up" the square                                #
        OP   PREV = ( INT pos )INT: IF pos = 1 THEN order ELSE pos - 1 FI;
        # operator to advance "across right" or "down" the square            #
        OP   NEXT = ( INT pos )INT: ( pos MOD order ) + 1;

        # fill in the square, starting from the middle of the top row        #
        INT col := ( order + 1 ) OVER 2;
        INT row := 1;
        FOR i TO order * order DO
            square[ row, col ] := i;
            IF square[ PREV row, NEXT col ] /= 0
            THEN
                # the up/right position is already taken, move down          #
                row := NEXT row
            ELSE
                # can move up and right                                      #
                row := PREV row;
                col := NEXT col
            FI
        OD;

        square
    FI # magic square # ;

# prints the magic square                                                    #
PROC print square = ( [,]INT square )VOID:
    BEGIN
        INT order = 1 UPB square;
        # calculate print width: negative so a leading "+" is not printed    #
        INT width := -1;
        INT mag   := order * order;
        WHILE mag >= 10 DO mag OVERAB 10; width MINUSAB 1 OD;
        # calculate the "magic sum"                                          #
        INT sum := 0;
        FOR i TO order DO sum +:= square[ 1, i ] OD;
        # print the square                                                   #
        print( ( "maqic square of order ", whole( order, 0 ), ": sum: ", whole( sum, 0 ), newline ) );
        FOR i TO order DO
            FOR j TO order DO write( ( " ", whole( square[ i, j ], width ) ) ) OD;
            write( ( newline ) )
        OD
    END # print square # ;

# test the magic square generation                                           #
FOR order BY 2 TO 7 DO print square( magic square( order ) ) OD
