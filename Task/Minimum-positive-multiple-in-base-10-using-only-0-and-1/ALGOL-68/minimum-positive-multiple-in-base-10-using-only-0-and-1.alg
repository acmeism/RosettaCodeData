BEGIN
    # returns B10 for the specified n or -1 if it cannot be found  #
    # based on Rick Heylen's C program linked from the OEIS site   #
    PROC find b10 = ( INT n )LONG INT:
         IF n < 1   THEN -1
         ELIF n = 1 THEN  1
         ELSE
            [ 0 : n ]LONG INT pow, val;
            INT      x, ten;
            LONG INT count;
            INT num = n;
            FOR i FROM 0 TO n - 1 DO pow[ i ] := val[ i ] := 0 OD;
            count := 0;
            ten   := 1;
            x     := 1;
            WHILE x < n
              AND BEGIN val[ x ] := ten;
                        FOR j FROM 0 TO n- 1 DO
                            IF pow[ j ] /= 0 THEN
                                IF INT j plus ten mod num = ( j + ten ) MOD num;
                                    pow[ j plus ten mod num ] = 0
                                THEN
                                    IF pow[ j ] /= x THEN pow[ j plus ten mod num ] := x FI
                                FI
                            FI
                        OD;
                        IF pow[ ten ] = 0 THEN pow[ ten ] := x FI;
                        ten *:= 10 MODAB num;
                        pow[ 0 ] = 0
                  END
            DO
                x +:= 1
            OD;
            x := num;
            IF pow[ 0 ] = 0 THEN - 1 # couldn't find B10 #
            ELSE
                LONG INT result := 0;
                WHILE x /= 0 DO
                    WHILE ( count -:= 1 ) > pow[ x MOD num ] - 1 DO result *:= 10 OD;
                    count := pow [ x MOD num ] -1;
                    result *:= 10 +:= 1;
                    x := SHORTEN ( num + x - val[ SHORTEN pow[ x MOD num ] ] ) MOD num
                OD;
                WHILE count > 0 DO result *:= 10 ; count -:= 1 OD;
                result
            FI
         FI # find B10 # ;
    # outputs B10 for the specified n #
    PROC show b10 = ( INT n )VOID:
         IF LONG INT b10 = find b10( n );
            b10 < 1
         THEN print( ( "Cannot find B10 for: ", whole( n, 0 ), newline ) )
         ELSE
             # found B10(n) #
             print( ( whole( n, -6 ), ": ", whole( b10, -32 ), " = ", whole( n, -6 ), " * ", whole( b10 OVER n, 0 ), newline ) )
         FI;
    # task test cases #
    FOR n FROM  1 TO  10 DO show b10( n ) OD;
    FOR n FROM 95 TO 105 DO show b10( n ) OD;
    []INT tests = ( 297, 576, 594, 891, 909, 999
                  , 1998, 2079, 2251, 2277
                  , 2439, 2997, 4878
                  );
    FOR n FROM LWB tests TO UPB tests DO show b10( tests[ n ] ) OD
END
