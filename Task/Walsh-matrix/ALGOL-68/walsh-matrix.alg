BEGIN # construct Walsh Matrices                                             #
  CO BEGIN code from the Kronecker product task                             CO
    # multiplies in-place the elements of the matrix a by the scaler b       #
    OP   *:= = ( REF[,]INT a, INT b )REF[,]INT:
    BEGIN
        FOR i FROM 1 LWB a TO 1 UPB a DO
            FOR j FROM 2 LWB a TO 2 UPB a DO
                a[ i, j ] *:= b
            OD
        OD;
        a
    END # *:= # ;
    # returns the Kronecker Product of the two matrices a and b              #
    # the result will have lower bounds of 1                                 #
    PRIO X = 6;
    OP   X = ( [,]INT a, b )[,]INT:
    BEGIN
        # normalise the matrices to have lower bounds of 1                   #
        [,]INT m = a[ AT 1, AT 1 ];
        [,]INT n = b[ AT 1, AT 1 ];
        # construct the result #
        INT r 1 size = 1 UPB n;
        INT r 2 size = 2 UPB n;
        [ 1 : 1 UPB m * 1 UPB n, 1 : 2 UPB m * 2 UPB n ]INT k;
        FOR i FROM 1 LWB m TO 1 UPB m DO
            FOR j FROM 2 LWB m TO 2 UPB m DO
                ( k[ 1 + ( ( i - 1 ) * r 1 size ) : i * r 1 size
                   , 1 + ( ( j - 1 ) * r 2 size ) : j * r 2 size
                   ] := n
                ) *:= m[ i, j ]
            OD
        OD;
        k
    END # X # ;
  CO END   code from the Kronecker product task                             CO
    # returns a Walsh matrix of oreder n                                     #
    OP   WALSH = ( INT n )[,]INT:
         BEGIN
            [,]INT w1 = ( (  1,  1 )
                        , (  1, -1 )
                        );
            FLEX[ 1 : 0, 1 : 0 ]INT result := 1;
            TO n DO
                result := result X w1
            OD;
            result
         END # WALSH # ;
    # returns Walsh matrix a sorted into sequency order                     #
    OP   SEQUENCYSORT = ( [,]INT a )[,]INT:
         BEGIN
            # sort the rows of the matrix into order of the number of sign  #
            # changes in the row                                            #
            [,]INT w = a[ AT 1, AT 1 ]; # normalise the matrix to have      #
                                        # lower bounds of 1                 #
            [ 1 : 1 UPB w, 1 : 2 UPB w ]INT result;
            # construct the resullt with the rows in order of the number of #
            # the number of sign changes in the original                    #
            # note the number of changes is unique and in 0 .. UPB a - 1    #
            FOR row FROM 1 TO 1 UPB w DO
                INT changes := 0;
                INT curr    := w[ row, 1 ];
                FOR col FROM 2 TO 2 UPB w DO
                    IF curr /= w[ row, col ] THEN
                        changes +:= 1;
                        curr     := w[ row, col ]
                    FI
                OD;
                result[ changes + 1, : ] := w[ row, : ]
            OD;
            result
         END # SEQUENCYSORT # ;
    CO returns r encoded with 1 = "_" and -1 = "#"                          CO
    OP   TOWSTRING = ( []INT r )STRING:
         BEGIN
            STRING result := "";
            FOR j FROM LWB r TO UPB r DO
                result +:= IF r[ j ] > 0 THEN "_" ELSE "#" FI
            OD;
            result
         END # TOWSTRING # ;
    # show the natural order and sequency order Walsh matrices of order 5    #
    [,]INT w5 = WALSH 5;
    [,]INT s5 = SEQUENCYSORT w5;
    FOR row FROM 1 TO 1 UPB s5 DO
        print( ( TOWSTRING w5[ row, : ], "        ", TOWSTRING s5[ row, : ], newline ) )
    OD
END
