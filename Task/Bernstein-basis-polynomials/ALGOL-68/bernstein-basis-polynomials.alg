BEGIN # Bernstein Basis Polynomials - translated from the Algol 60      #
      # Note the "Subrptoghram (n) designations are as specified in the #
      # task                                                            #

    MODE BERNTWO   = STRUCT( STRING label, REAL b0, b1, b2 );
    MODE BERNTHREE = STRUCT( STRING label, REAL b0, b1, b2, b3 );

    PRIO EVAL      = 5; # set the priority of the dyadic EVAL  #

    # Subprogram (1): transform monomial coefficients          #
    #     a0, a1, a2 to Bernstein coefficients b0, b1, b2      #
    PROC tobern2 = ( REAL a0, a1, a2, REF BERNTWO b )VOID:
         BEGIN
            b0 OF b := a0;
            b1 OF b := a0 + ((1/2) * a1);
            b2 OF b := a0 + a1 + a2
         END # tobern2 # ;

    # Subprogram (2): evaluate, at t, the polynomial with      #
    #    Bernstein coefficients b0, b1, b2. Use de Casteljau's #
    #    algorithm                                             #
    OP EVAL = ( BERNTWO b, REAL t )REAL:
         BEGIN
            REAL s    = 1 - t;
            REAL b01  = (s * b0 OF b) + (t * b1 OF b);
            REAL b12  = (s * b1 OF b) + (t * b2 OF b);
            (s * b01) + (t * b12)
         END # EVAL # ;

    # Subprogram (3): transform monomial coefficients          #
    #     a0, a1, a2, a3 to Bernstein coefficients b0, b1,     #
    #     b2, b3                                               #
    PROC tobern3 = ( REAL a0, a1, a2, a3, REF BERNTHREE b )VOID:
         BEGIN
            b0 OF b := a0;
            b1 OF b := a0 + ((1/3) * a1);
            b2 OF b := a0 + ((2/3) * a1) + ((1/3) * a2);
            b3 OF b := a0 + a1 + a2 + a3
         END # tobern3 # ;

    # Subprogram (4): evaluate, at t, the polynomial           #
    #    with Bernstein coefficients b0, b1, b2, b3. Use       #
    #    de Casteljau's algorithm                              #
    OP EVAL = ( BERNTHREE b, REAL t )REAL:
         BEGIN
            REAL s    = 1 - t;
            REAL b01  = (s * b0 OF b) + (t * b1 OF b);
            REAL b12  = (s * b1 OF b) + (t * b2 OF b);
            REAL b23  = (s * b2 OF b) + (t * b3 OF b);
            REAL b012 = (s * b01) + (t * b12);
            REAL b123 = (s * b12) + (t * b23);
            (s * b012) + (t * b123)
         END # EVAL #;

    # Subprogram (5): transform the quadratic Bernstein        #
    #    coefficients q0, q1, q2 to the cubic Bernstein        #
    #    coefficients c0, c1, c2, c3;                          #
    OP   TOBERNTHREE = ( BERNTWO q )BERNTHREE:
         BEGIN
            HEAP BERNTHREE c;
            b0 OF c := b0 OF q;
            b1 OF c := ((1/3) * b0 OF q) + ((2/3) * b1 OF q);
            b2 OF c := ((2/3) * b1 OF q) + ((1/3) * b2 OF q);
            b3 OF c := b2 OF q;
            c
         END # TOBERNTHREE # ;

    BEGIN

        # returns x as a string without trailing 0 decoimals    #
        PROC f = ( REAL x )STRING:
             BEGIN
                 STRING v       := fixed( x, -14, 11 );
                 INT    end pos := UPB v;
                 WHILE IF end pos < LWB v THEN FALSE ELSE v[ end pos ] = "0" FI DO
                     end pos -:= 1
                 OD;
                 IF end pos >= LWB v THEN
                     IF v[ end pos ] = "." THEN end pos -:= 1 FI
                 FI;
                 INT start pos := LWB v;
                 WHILE IF start pos > end pos THEN FALSE ELSE v[ start pos ] = " " FI DO
                     start pos +:= 1
                 OD;
                 IF end pos < start pos THEN "0" ELSE v[ start pos : end pos ] FI
             END # f # ;

        PRIO SHOWEVAL = 5;
        # prints the result of evaluating p with x             #
        OP   SHOWEVAL = ( BERNTWO   p, REAL x )VOID:
             print( ( "  ", label OF p, " ( ", f( x ), " ) = ", f( p EVAL x ), newline ) );
        # prints the result of evaluating p with x             #
        OP   SHOWEVAL = ( BERNTHREE p, REAL x )VOID:
             print( ( "  ", label OF p, " ( ", f( x ), " ) = ", f( p EVAL x ), newline ) );
        # returns a string representation of the values of p   #
        OP   TOSTRING = ( BERNTWO   p )STRING:
             "( " + f( b0 OF p ) + ", " + f( b1 OF p ) + ", " + f( b2 OF p ) + " )";
        # returns a string representation of the values of p   #
        OP   TOSTRING = ( BERNTHREE p )STRING:
             "( " + f( b0 OF p ) + ", " + f( b1 OF p ) + ", " + f( b2 OF p ) + ", " + f( b3 OF p ) + " )";
        # returns a string representation of the values of p   #
        OP   TOSTRING = ( []REAL p )STRING:
             BEGIN
                STRING result    := "(", separator := "";
                FOR i FROM LWB p TO UPB p DO
                    result   +:= separator + " " + f( p[ i ] );
                    separator := ","
                OD;
                result + " )"
             END # TOSTRING # ;

        BERNTWO   p2 := BERNTWO  ( "p", 0, 0, 0 );
        BERNTWO   q2 := BERNTWO  ( "q", 0, 0, 0 );

        BERNTHREE p3 := BERNTHREE( "p", 0, 0, 0, 0 );
        BERNTHREE q3 := BERNTHREE( "q", 0, 0, 0, 0 );
        BERNTHREE r3 := BERNTHREE( "r", 0, 0, 0, 0 );

        REAL p0m = 1, p1m = 0, p2m = 0;
        REAL q0m = 1, q1m = 2, q2m = 3;
        REAL r0m = 1, r1m = 2, r2m = 3, r3m = 4;

        tobern2( p0m, p1m, p2m, p2 );
        tobern2( q0m, q1m, q2m, q2 );
        print( ( "Subprogram (1) examples:", newline ) );
        print( ( "  mono ", TOSTRING []REAL( p0m, p1m, p2m ), " --> bern ", TOSTRING p2, newline ) );
        print( ( "  mono ", TOSTRING []REAL( q0m, q1m, q2m ), " --> bern ", TOSTRING q2, newline ) );

        print( ( "Subprogram (2) examples:", newline ) );
        p2 SHOWEVAL 0.25;
        p2 SHOWEVAL 7.50;
        q2 SHOWEVAL 0.25;
        q2 SHOWEVAL 7.50;

        tobern3( p0m, p1m, p2m, 0,   p3 );
        tobern3( q0m, q1m, q2m, 0,   q3 );
        tobern3( r0m, r1m, r2m, r3m, r3 );
        print( ( "Subprogram (3) examples:", newline ) );
        print( ( "  mono ", TOSTRING []REAL( p0m, p1m, p2m, 0   ), " --> bern ", TOSTRING p3, newline ) );
        print( ( "  mono ", TOSTRING []REAL( q0m, q1m, q2m, 0   ), " --> bern ", TOSTRING q3, newline ) );
        print( ( "  mono ", TOSTRING []REAL( r0m, r1m, r2m, r3m ), " --> bern ", TOSTRING r3, newline ) );

        print( ( "Subprogram (4) examples:", newline ) );
        p3 SHOWEVAL 0.25;
        p3 SHOWEVAL 7.50;
        q3 SHOWEVAL 0.25;
        q3 SHOWEVAL 7.50;
        r3 SHOWEVAL 0.25;
        r3 SHOWEVAL 7.50;

        print( ( "Subprogram (5) examples:", newline ) );
        print( ( "  bern ", TOSTRING p2, " --> bern ", TOSTRING TOBERNTHREE p2, newline ) );
        print( ( "  bern ", TOSTRING q2, " --> bern ", TOSTRING TOBERNTHREE q2, newline ) )

    END

END
