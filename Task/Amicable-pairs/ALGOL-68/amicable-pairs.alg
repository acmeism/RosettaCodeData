BEGIN # find amicable pairs p1, p2 where each is equal to the other's proper divisor sum #
    [ 1 : 20 000 ]INT pd sum; # table of proper divisors #
    FOR n TO UPB pd sum DO pd sum[ n ] := 1 OD;
    FOR i FROM 2 TO UPB pd sum
        DO FOR j FROM i + i BY i TO UPB pd sum DO
            pd sum[ j ] +:= i
        OD
    OD;
    # find the amicable pairs up to 20 000                            #
    FOR p1 TO UPB pd sum DO
        FOR p2 FROM p1 + 1 TO UPB pd sum DO
            IF pd sum[ p1 ] = p2 AND pd sum[ p2 ] = p1 THEN
                print( ( whole( p1, -6 ), " and ", whole( p2, -6 ), " are an amicable pair", newline ) )
            FI
        OD
    OD
END
