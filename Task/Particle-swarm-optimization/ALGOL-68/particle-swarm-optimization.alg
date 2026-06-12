BEGIN # particle swarm optimisation - translation of Go #

    MODE FF = PROC([]REAL)REAL;

    MODE PARAMETERS = STRUCT( REAL omega, phip, phig );

    MODE STATE      = STRUCT( INT           iter
                            , REF[]REAL     gbpos
                            , REAL          gbval
                            , REF[]REAL     min
                            , REF[]REAL     max
                            , PARAMETERS    params
                            , REF[,]REAL    pos
                            , REF[,]REAL    vel
                            , REF[,]REAL    bpos
                            , REF[]REAL     bval
                            , INT           nparticles
                            , INT           ndims
                            );

    OP   FMT = ( INT    v )STRING: whole( v, 0 );
    OP   FMT = ( REAL   v )STRING: fixed( v, -18, 15 );
    OP   FMT = ( []REAL v )STRING:
         BEGIN
            STRING result := "", prefix := "";
            FOR i FROM LWB v TO UPB v DO
                result +:= prefix + FMT v[ i ];
                prefix := " "
            OD;
            "[" + result + "]"
         END # FMT # ;
    PROC println = ( STRING line )VOID: print( ( line, newline ) );

    PRIO REPORT = 9;
    OP   REPORT = ( STATE s, STRING testfunc )VOID:
         BEGIN
             println( "Test Function        : " + testfunc );
             println( "Iterations           : " + FMT iter OF s );
             println( "Global Best Position : " + FMT gbpos OF s );
             println( "Global Best Value    : " + FMT gbval OF s )
         END # REPORT # ;

    PROC psoinit = ( []REAL min, max, PARAMETERS params, INT nparticles )REF STATE:
         BEGIN
            INT ndims = ( UPB min - LWB min ) + 1;
            HEAP STATE result
              := STATE( # iter       # 0
                      , # gbpos      # HEAP[                 1 : ndims ]REAL
                      , # gbval      # max real
                      , # min        # HEAP[                 1 : ndims ]REAL := min[ AT 1 ]
                      , # max        # HEAP[                 1 : ndims ]REAL := max[ AT 1 ]
                      , # params     # params
                      , # pos        # HEAP[ 1 : nparticles, 1 : ndims ]REAL
                      , # val        # HEAP[ 1 : nparticles, 1 : ndims ]REAL
                      , # bpos       # HEAP[ 1 : nparticles, 1 : ndims ]REAL
                      , # bval       # HEAP[ 1 : nparticles            ]REAL
                      , # nparticles # nparticles
                      , # ndims      # ndims
                      );
            FOR i TO nparticles DO
                (  pos OF result )[ i, : ] := min[ AT 1 ];
                ( bpos OF result )[ i, : ] := min[ AT 1 ];
                ( bval OF result )[ i    ] := max real;
                FOR j TO ndims DO ( vel OF result )[ i, j ] := 0 OD
            OD;
            FOR i TO ndims DO
                ( gbpos OF result )[ i ] := max real
            OD;
            result
         END # psoinit # ;

    PRIO PSO = 9;
    OP   PSO = ( REF STATE y, FF fn )REF STATE:    # updates in-place the STATE y #
         BEGIN
            INT   nparticles = nparticles OF y, ndims = ndims OF y;
            [ 1 : nparticles ]REAL v;
            PARAMETERS    p     = params OF y;
            REAL          omega =  omega OF p, phip = phip OF p, phig = phig OF p;
            REF[]REAL     gbpos =  gbpos OF y;
            REF[]REAL     min   =    min OF y;
            REF[]REAL     max   =    max OF y;
            REF[,]REAL    pos   =    pos OF y;
            REF[,]REAL    vel   =    vel OF y;
            REF[,]REAL    bpos  =   bpos OF y;
            REF[]REAL     bval  =   bval OF y;
            FOR j TO nparticles DO
                # evaluate #
                v[ j ] := fn( pos[ j, : ] );
                # update #
                IF v[ j ] < bval[ j ] THEN
                    bpos[ j, : ] := pos[ j, : ]; # FOR TIO.RUN, replace this line with: #
                                                 # FOR k TO ndims DO bpos[ j, k ] := pos[ j, k ] OD; #
                    bval[ j ] := v[ j ]
                FI;
                IF bval[ j ] < gbval OF y THEN
                    gbval OF y := bval[ j    ];
                    gbpos      := bpos[ j, : ]
                FI
            OD;
            REAL rg = random;
            FOR j TO nparticles DO
                # migrate #
                REAL rp  = random;
                BOOL ok := TRUE;
                FOR k TO ndims DO
                    vel[ j, k ] := omega * vel[ j, k ]
                                 + phip * rp * ( bpos[ j, k ] - pos[ j, k ] )
                                 + phig * rg * ( gbpos[   k ] - pos[ j, k ] );
                    pos[ j, k ] +:= vel[ j, k ];
                    IF ok THEN
                        ok := min[ k ] < pos[ j, k ] AND max[ k ] > pos[ j, k ]
                    FI
                OD;
                IF NOT ok THEN
                    FOR k TO ndims DO
                        pos[ j, k ] := min[ k ] + ( max[ k ] - min[ k ] ) * random
                    OD
                FI
            OD;
            iter OF y +:= 1;
            y
         END # pso # ;

    # performs n iterations of the STATE y, updating y in-place #
    PROC iterate = ( FF fn, INT n, REF STATE y )REF STATE:
         BEGIN
            TO n DO y PSO fn OD;
            y
         END # iterate # ;

    PROC mccormick = ( []REAL x )REAL:
         BEGIN
            REAL  a = x[ LWB x ], b = x[ LWB x + 1 ];
            sin( a + b ) + ( a - b ) * ( a - b ) + 1.0 + 2.5 * b - 1.5 * a
         END # mccormick # ;

    PROC michalewicz = ( []REAL x )REAL:
         BEGIN
            REAL sum := 0.0;
            FOR i FROM LWB x TO UPB x DO
                REAL j = x[ i ];
                REAL k = sin( i * j * j / pi );
                sum  +:= sin( j ) * ( k ^ 20 )
            OD;
            - sum
         END # michalewicz # ;


    BEGIN

        STATE st := psoinit( # min        # ( -1.5, -3.0 )
                           , # max        # (  4.0,  4.0 )
                           , # params     # (  0.0,  0.6, 0.3 )
                           , # nparticles # 100
                           );
        st := iterate( mccormick, 40, st );
        st REPORT "McCormick";
        println( "f(-.54719, -1.54719) : " + FMT mccormick( ( -0.54719, -1.54719 ) ) );
        println( "" );

        st := psoinit( # min        # ( 0.0, 0.0 )
                     , # max        # ( pi,  pi  )
                     , # params     # ( 0.3, 0.3, 0.3 )
                     , # nparticles # 1000
                     );
        st := iterate( michalewicz, 30, st );
        st REPORT "Michalewicz (2D)";
        println( "f(2.20, 1.57)        : " + FMT michalewicz( ( 2.2, 1.57 ) ) )
    END
END
