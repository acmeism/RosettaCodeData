BEGIN # Solve the travelling salesman problem using the Held–Karp algorithm  #
      # translated from the FreeBASIC sample                                 #

    REAL inf = max real;

    # utility operators to allow bit manipulation on integers                #
    PR read "bits.incl.a68" PR

    # returns the minimum cost tour using the Held-Karp algorithm            #
    #         min cost is set to the minimum cost                            #
    PROC held karp = ( [,]REAL dist, REF REAL min cost )[]INT:
         IF LWB dist /= 0 THEN
            print( ( "LWB dist must be 0", newline ) );
            min cost := inf;
            [ 0 : -1 ]INT no values;
            no values
         ELSE
            INT n        = 1 UPB dist + 1;
            INT num mask = 1 SHL n;

            # dp[mask,j] = minimum cost to reach subset 'mask' ending at j   #
            [ 0 : num mask - 1, 0 : n - 1 ]REAL dp;

            # parent[mask,j] = previous node before j in optimal path for    #
            #                  (mask, j)                                     #
            [ 0 : num mask - 1, 0 : n - 1 ]INT  parent;

            FOR i FROM 0 TO num mask - 1 DO    # Initialize dp with infinity #
                FOR j FROM 0 TO n - 1 DO
                    dp[     i, j ] := inf;
                    parent[ i, j ] := -1
                OD
            OD;

            # Base case: start at node 0, mask = 1<<0                        #
            dp[ 1, 0 ] := 0;

            # Iterate over all subsets that include node 0                   #
            FOR mask TO num mask - 1 DO
                IF ODD mask THEN    # We always require the tour to start at #
                    INT two to j := 1;       # node 0 so mask must include 1 #
                    FOR j TO n - 1 DO
                        two to j *:= 2;
                        IF ( mask XOR two to j ) /= 0 THEN  # j is in subset #
                            INT prev mask = mask XOR two to j;
                            # Try all possibilities of coming to j from      #
                            # some k in prev mask                            #
                            INT two to k := 1;
                            FOR k FROM 0 TO n - 1 DO
                                IF ( prev mask AND two to k ) /= 0 THEN
                                    IF   REAL cost = dp[ prev mask, k ] + dist[ k, j ];
                                         cost < dp[ mask, j ]
                                    THEN dp[     mask, j ] := cost;
                                         parent[ mask, j ] := k
                                    FI
                                FI;
                                two to k *:= 2
                            OD
                        FI
                    OD
                FI
            OD;

            # Close the tour: return to node 0                               #
            INT  full mask = ( 1 SHL n ) - 1;
            INT  last     := -1;

            min cost := inf;
            FOR j TO n - 1 DO
                IF   REAL cost = dp[ full mask, j ] + dist[ j, 0 ];
                     cost < min cost
                THEN min cost := cost;
                     last     := j
                FI
            OD;

            # Reconstruct path #
            [ 0 : n ]INT path;        # n + 1 elements for the complete tour #
            path[ n ] := 0;                                  # End at node 0 #
            INT path index := n - 1;

            INT path mask := full mask;
            INT curr := last;

            WHILE curr /= -1 AND curr /= 0 DO
                path[ path index ] := curr;
                path index -:= 1;

                INT prev = parent[ path mask, curr ];
                path mask XORAB ( 1 SHL curr );
                curr := prev
            OD;

            path[ path index ] := 0; # Start at node 0 #
            path
         FI # held karp # ;

    BEGIN # Example test case: 4 cities, symmetric distance matrix           #
        [,]REAL dist matrix = ( (  0,  2,  9, 10 )
                              , (  1,  0,  6,  4 )
                              , ( 15,  7,  0,  8 )
                              , (  6,  3, 12,  0 )
                              );

        REAL min cost := inf;
        # For a 4-city problem, the path has 5 elements                      #
        # (including the return to the start)                                #
        []INT path = held karp( dist matrix[ AT 0, AT 0 ], min cost );

        print( ( "Minimum tour cost: ", fixed( min cost, 0, 4 ), newline ) );
        print( ( "Tour: " ) );
        FOR i FROM 0 TO UPB path - 1 DO
            print( ( whole( path[ i ], 0 ), " -> " ) )
        OD;
        print( ( whole( path[ UPB path ], 0 ), newline ) )
    END
END
