BEGIN # Floyd-Warshall algorithm - translated from the Lua sample #

    OP   FMT = ( REAL v )STRING:
         BEGIN
            STRING result := fixed( ABS v, 0, 15 );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            IF v < 0 THEN "-" ELSE " " FI + result
         END # FMT # ;

    PROC print result = ( [,]REAL dist, [,]INT nxt )VOID:
         BEGIN
            print( ( "pair     dist    path", newline ) );
            FOR i FROM 1 LWB nxt TO 1 UPB nxt DO
                FOR j FROM 2 LWB nxt TO 2 UPB nxt DO
                    IF i /= j THEN
                        INT    u    := i + 1;
                        INT    v     = j + 1;
                        print( ( whole( u, 0 ),    " -> ",  whole( v, 0 ), "    "
                               , FMT dist[ i, j ], "     ", whole( u, 0 )
                               )
                             );
                        WHILE u := nxt[ u - 1, v - 1 ];
                              print( ( " -> " +whole( u, 0 ) ) );
                              u /= v
                        DO SKIP OD;
                        print( ( newline ) )
                    FI
                OD
            OD
         END # print result # ;

    PROC floyd warshall = ( [,]INT weights, INT num vertices )VOID:
         BEGIN

            REAL infinity = max real;

            [ 0 : num vertices - 1, 0 : num vertices - 1 ]REAL dist;
            FOR i FROM LWB dist TO 1 UPB dist DO
                FOR j FROM 2 LWB dist TO 2 UPB dist DO
                    dist[ i, j ] := infinity
                OD
            OD;

            FOR i FROM 1 LWB weights TO 1 UPB weights DO
                # the weights array is one based #
                []INT w = weights[ i, : ];
                dist[ w[ 1 ] - 1, w[ 2 ] - 1 ] := w[ 3 ]
            OD;

            [ 0 : num vertices - 1, 0 : num vertices - 1 ]INT nxt;
            FOR i FROM LWB nxt TO 1 UPB nxt DO
                FOR j FROM 2 LWB nxt TO 2 UPB nxt DO
                    nxt[ i, j ] := IF i /= j THEN j + 1 ELSE 0 FI
                OD
            OD;

            FOR k FROM 2 LWB dist TO 2 UPB dist DO
                FOR i FROM 1 LWB dist TO 1 UPB dist DO
                    FOR j FROM 2 LWB dist TO 2 UPB dist DO
                        IF dist[ i, k ] /= infinity AND dist[ k, j ] /= infinity THEN
                            IF dist[ i, k ] + dist[ k, j ] < dist[ i, j ] THEN
                                dist[ i, j ] := dist[ i, k ] + dist[ k, j ];
                                nxt[  i, j ] := nxt[  i, k ]
                            FI
                        FI
                    OD
                OD
             OD;

             print result( dist, nxt )
         END # floyd warshall # ;

    [,]INT weights = ( ( 1, 3, -2 )
                     , ( 2, 1,  4 )
                     , ( 2, 3,  3 )
                     , ( 3, 4,  2 )
                     , ( 4, 2, -1 )
                     );
    INT num vertices = 4;
    floyd warshall( weights, num vertices )

END
