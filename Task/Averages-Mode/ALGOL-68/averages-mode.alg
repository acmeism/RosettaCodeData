BEGIN # find the mode (most frequent value) of a set of items                #
    PR read "rows.incl.a68" PR               # include row (array) utilities #
    # returns the mode(s) of a - similar operators could be defined for      #
    #                            types other than INT                        #
    OP MODEOF = ( []INT a )[]INT:
       IF LWB a > UPB a THEN []INT() # no data                               #
       ELSE                          # have data                             #
           [ LWB a : UPB a ]INT sorted data := a;
           QUICKSORT sorted data FROMELEMENT LWB sorted data TOELEMENT UPB sorted data;
           INT distinct count = BEGIN  # count the number of distinct values #
                                    INT count := 1;
                                    INT value := sorted data[ LWB sorted data ];
                                    FOR i FROM LWB sorted data + 1 TO UPB sorted data DO
                                        IF value /= sorted data[ i ] THEN
                                            count +:= 1;
                                            value  := sorted data[ i ]
                                        FI
                                    OD;
                                    count
                                END;
           INT current value := sorted data[ LWB sorted data ];
           INT max count     := 0;
           INT current count := 1;
           INT s pos         := LWB sorted data + 1;
           # allow for the maximum possible number of modes                  #
           [ 1 : distinct count ]INT modes;
           INT mode count    := 1;
           modes[ 1 ]        := current value;
           WHILE s pos <= UPB sorted data DO
               s pos +:= 1;
               WHILE IF s pos > UPB sorted data
                     THEN FALSE
                     ELSE sorted data[ s pos ] = current value
                     FI
               DO
                   current count +:= 1;
                   s pos         +:= 1
               OD;
               IF current count > max count THEN
                   max count                 := current count;
                   modes[ mode count  := 1 ] := sorted data[ s pos - 1 ]
               ELIF current count = max count THEN
                   modes[ mode count +:= 1 ] := sorted data[ s pos - 1 ]
               FI;
               current count := 0;
               IF s pos <= UPB sorted data THEN
                   current value := sorted data[ s pos ]
               FI
           OD;
           modes[ 1 : mode count ]
       FI # MODEOF # ;

    # test cases as in the 11l sample                                        #
    SHOW MODEOF []INT( 1, 3, 6, 6, 6, 6, 7, 7, 12, 12, 17 );print( ( newline ) );
    SHOW MODEOF []INT( 1, 1, 2, 4, 4 )                     ;print( ( newline ) );
    # test cases as in the Action! sample                                    #
    SHOW MODEOF []INT( 1, 3, 5, 7, 3, 1, 3, 7, 7, 3, 3 )   ;print( ( newline ) );
    SHOW MODEOF []INT( 7, 13, 5, 13, 7, 2, 7, 10, 13 )     ;print( ( newline ) );
    SHOW MODEOF []INT( 5 )                                 ;print( ( newline ) );
    # additional test case                                                   #
    SHOW MODEOF []INT( 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 )   ;print( ( newline )

END
