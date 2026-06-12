BEGIN # find the characters that occur once only in a list of stings        #
    # returns the characters that occur only once in the elements of s      #
    OP UNIQUE = ( []STRING s )STRING:
       BEGIN
            [ 0 : max abs char ]INT counts; # counts of used characters     #
            FOR i FROM LWB counts TO UPB counts DO counts[ i ] := 0 OD;
            # count the occurances of the characters in the elements of s   #
            FOR i FROM LWB s TO UPB s DO
                FOR j FROM LWB s[ i ] TO UPB s[ i ] DO
                    counts[ ABS s[ i ][ j ] ] +:= 1
                OD
            OD;
            # construct a string of the characters that occur only once     #
            STRING result := "";
            FOR i FROM LWB counts TO UPB counts DO
                IF counts[ i ] = 1 THEN result +:= REPR i FI
            OD;
            result
       END; # UNIQUE #
    # task test case                                                        #
    print( ( UNIQUE []STRING( "133252abcdeeffd",  "a6789798st",  "yxcdfgxcyz" ), newline ) )
END
