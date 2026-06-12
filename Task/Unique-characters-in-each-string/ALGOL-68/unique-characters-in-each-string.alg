BEGIN # find the characters that occur once only in each element of a list  #
      # of stings                                                           #
    OP UNIQUEINEACH = ( []STRING s )STRING:
       IF INT required count = ( UPB s + 1 ) - LWB s;
          required count < 1
       THEN "" # the list is empty #
       ELSE    # non-empty list #
            [ 0 : max abs char ]INT counts; # counts of used characters     #
            [ 0 : max abs char ]INT all;
            FOR i FROM LWB all TO UPB all DO all[ i ] := 0 OD;
            # count the occurances of the characters in the elements of s   #
            FOR i FROM LWB s TO UPB s DO
                FOR j FROM LWB counts TO UPB counts DO counts[ j ] := 0 OD;
                FOR j FROM LWB s[ i ] TO UPB s[ i ] DO
                    counts[ ABS s[ i ][ j ] ] +:= 1
                OD;
                FOR j FROM LWB counts TO UPB counts DO
                    # the character is unique in this string                #
                    IF counts[ j ] = 1 THEN all[ j ] +:= 1 FI
                OD
            OD;
            # construct a string of the characters that occur only once     #
            # in each string                                                #
            STRING result := "";
            FOR i FROM LWB all TO UPB all DO
                IF all[ i ] = required count THEN result +:= REPR i FI
            OD;
            result
       FI; # UNIQUEINEACH #
    # task test case                                                        #
    STRING unique = UNIQUEINEACH []STRING( "1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz" );
    FOR c FROM LWB unique TO UPB unique DO print( ( " ", unique[ c ] ) ) OD; print( ( newline ) )
END
