BEGIN # find amicable pairs p1, p2 where each is equal to the other's proper divisor sum #
    [ 1 : 20 000 ]INT pd sum; # table of proper divisors #
    FOR n TO UPB pd sum DO pd sum[ n ] := 1 OD;
    FOR i FROM 2 TO UPB pd sum
        DO FOR j FROM i + i BY i TO UPB pd sum DO
            pd sum[ j ] +:= i
        OD
    OD;
    # find the amicable pairs up to 20 000                            #
    FOR p1 TO UPB pd sum - 1 DO
        INT pd sum p1 = pd sum[ p1 ];
        IF pd sum p1 > p1 AND pd sum p1 <= UPB pd sum THEN
            IF pd sum[ pd sum p1 ] = p1 THEN
                print( ( whole( p1, -6 ), " and ", whole( pd sum p1, -6 ), " are an amicable pair", newline ) )
            FI
        FI
    OD
END
