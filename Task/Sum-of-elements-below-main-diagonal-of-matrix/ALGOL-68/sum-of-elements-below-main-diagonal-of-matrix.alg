BEGIN # sum the elements below the main diagonal of a matrix  #
    # returns the sum of the elements below the main diagonal #
    # of m, m must be a square matrix                         #
    OP   LOWERSUM = ( [,]INT m )INT:
         IF 1 LWB m /= 2 LWB m OR 1 UPB m /= 2 UPB m THEN
            # the matrix isn't square                         #
            print( ( "Matrix must be suare for LOWERSUM", newline ) );
            stop
         ELSE
            # have a square matrix                            #
            INT sum := 0;
            FOR r FROM 1 LWB m + 1 TO 1 UPB m DO
                 FOR c FROM 1 LWB m TO r - 1 DO
                     sum +:= m[ r, c ]
                 OD
            OD;
            sum
         FI; # LOWERSUM #
    # task test case                                          #
    print( ( whole( LOWERSUM [,]INT( (  1,  3,  7,  8, 10 )
                                   , (  2,  4, 16, 14,  4 )
                                   , (  3,  1,  9, 18, 11 )
                                   , ( 12, 14, 17, 18, 20 )
                                   , (  7,  1,  3,  9,  5 )
                                   )
                  , 0
                  )
            , newline
            )
          )
END
