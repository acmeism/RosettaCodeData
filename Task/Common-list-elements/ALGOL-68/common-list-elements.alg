BEGIN # find common elements of lists                                        #

    PRIO COMMON = 1;
    # returns the common elements of a and b                                 #
    OP   COMMON = ( []INT a, b )[]INT:
         IF  INT a len = ( UPB a - LWB a ) + 1;
             INT b len = ( UPB b - LWB b ) + 1;
             a len < 1 OR b len < 1
         THEN                               # one or both lists is/are empty #
             []INT()
         ELIF a len < b len
         THEN                       # both lists are non-empty, b is shorter #
              b COMMON a
         ELSE          # both lists are non-empty, a is at most as long as b #
             [ 1 : b len ]INT result;
             [ LWB a : UPB a ]BOOL used;
             FOR i FROM LWB a TO UPB a DO used[ i ] := FALSE OD;
             INT r pos := 0;
             FOR b pos FROM LWB b TO UPB b DO
                 BOOL found := FALSE;
                 FOR a pos FROM LWB a TO UPB a WHILE NOT found DO
                     IF NOT used[ a pos ] THEN
                         IF ( found := a[ a pos ] = b[ b pos ] ) THEN
                             result[ r pos +:= 1 ] := b[ b pos ];
                             used[ a pos ] := TRUE
                         FI
                     FI
                 OD
             OD;
             result[ : r pos ]
         FI # COMMON # ;
    # returns the common elements in the lists in nums                      #
    OP   COMMON = ( [][]INT nums )[]INT:
         IF   1 UPB nums < 1 LWB nums THEN                       # no lists #
             []INT()
         ELIF 1 UPB nums = 1 LWB nums THEN                  # only one list #
             nums[ LWB nums ]
         ELSE                                           # two or more lists #
             FLEX[ 1 : 0 ]INT result;
             result := nums[ LWB nums ] COMMON nums[ LWB nums + 1 ];
             FOR i FROM LWB nums + 2 TO UPB nums DO
                 result := result COMMON nums[ i ]
             OD;
             result
         FI # COMMON # ;

    print( ( COMMON [][]INT( ( 2, 5, 1, 3, 8, 9, 4, 6 )
                           , ( 3, 5, 6, 2, 9, 8, 4 )
                           , ( 1, 3, 7, 6, 9 )
                           )
           )
         )
END
