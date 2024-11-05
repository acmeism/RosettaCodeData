BEGIN # draw some Cistercian Numerals                                        #

    INT ch = 6;       # height of the representation of a Cistercian Numeral #
    INT cw = 5;        # width of the representation of a Cistercian Numeral #
    INT cm = ( cw + 1 ) OVER 2; # mid-point of a line in the representation  #
                                                   # of a Cistercian Numeral #
    # returns a 5x6 CHAR array representing the Cistercian Nuneral of n      #
    #         0 <= m <= 9999 must be TRUE                                    #
    OP   TOCISTERCIAN = ( INT n )[,]CHAR:
         IF n < 0 OR n > 9999 THEN                               # invalid n #
            ( "?????", "?????", "?????", "?????", "?????", "?????" )
         ELSE                                                      # n is OK #
            # if ch isn't 6 or cw isn't 5, the strinngs above and below will #
            [ 1 : ch, 1 : cw ]CHAR cn :=               # need to be adjusted #
                ( "     ", "  |  ", "  |  ", "  |  ", "  |  ", "  |  " );
            []STRING t digits = ( #1# "__",      #2# ";;__",    #3# "; /;/"
                                , #4# ";\; \",   #5# "__; /;/", #6# "; |; |"
                                , #7# "_; |; |", #8# "; |;_|",  #9# "_; |;_|"
                                );
            []STRING b digits = ( #1# "__",      #2# ";;__",    #3# "\; \"
                                , #4# " /;/",    #5# "_/;/",    #6# " |; |"
                                , #7# "_|; |",   #8# " |; |;_", #9# "_|; |;_"
                                );
            # adds 1 digit to the numeral                                     #
            PROC add digit = ( INT digit, BOOL flip horizontal, flip vertical )VOID:
                 IF digit > 0 THEN                     # have a visible digit #
                    STRING d   = IF flip vertical THEN b digits[ digit ] ELSE t digits[ digit ] FI;
                    INT x     := IF flip horizontal THEN -1 ELSE 1 FI + cm;
                    INT y     := IF flip vertical   THEN ch ELSE 1 FI;
                    INT x init = x;
                    INT x step = IF flip horizontal THEN -1 ELSE 1 FI;
                    INT y step = IF flip vertical   THEN -1 ELSE 1 FI;
                    FOR c pos FROM LWB d TO UPB d DO
                        CHAR c = d[ c pos ];
                        IF c = ";" THEN
                            y +:= y step;
                            x  := x init
                        ELSE
                            cn[ y, x ] := IF ( flip horizontal XOR flip vertical ) THEN
                                              IF c = "/" THEN "\" ELIF c = "\" THEN "/" ELSE c FI
                                          ELSE c
                                          FI;
                            x +:= x step
                        FI
                    OD
                 FI # add digit # ;
            INT v := n;
            add digit( v MOD 10, FALSE, FALSE ); v OVERAB 10;
            add digit( v MOD 10, TRUE,  FALSE ); v OVERAB 10;
            add digit( v MOD 10, FALSE, TRUE  ); v OVERAB 10;
            add digit( v MOD 10, TRUE,  TRUE  );
            cn
         FI # TOCISTERCIAN # ;
    # inserts a Cistercian Numeral representation of n into an set of lines  #
    PROC insert cistercian = ( [,]CHAR cn, REF[]STRING lines, INT pos )VOID:
         FOR i FROM 1 TO ch DO
             lines[ i ][ pos : ( pos + cw ) - 1 ] := STRING( cn[ i, : ] )
         OD # print cistercian # ;

    BEGIN
        []INT tests = ( 0, 20, 300, 4000, 5555, 6789, 1968 );
        # construct an array of blank lines and insert the                   #
        [ 1 : ch ]STRING lines;            # Cistercian Numereals into them  #
        FOR i FROM LWB lines TO UPB lines DO
            lines[ i ] := " " * ( ( ( UPB tests -LWB tests ) + 1 ) * ( cw * 2 ) )
        OD;
        FOR i FROM LWB tests TO UPB tests DO print( ( whole( tests[ i ], - cw ), " " * cw ) ) OD;
        print( ( newline ) );
        INT i pos := 1 - ( cw * 2 );
        FOR i FROM LWB tests TO UPB tests DO
            insert cistercian( TOCISTERCIAN tests[ i ], lines, i pos +:= cw * 2 )
        OD;
        FOR i FROM LWB lines TO UPB lines DO print( ( lines[ i ], newline ) ) OD
    END
END
