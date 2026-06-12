BEGIN # Numerical integration using an Adaptive Simpson's method #

    PROC quad asr = ( PROC(REAL)REAL f, REAL a, b, eps )REAL:
         BEGIN
            MODE TRIPLE = STRUCT( REAL m, fm, simp );

            # "structured" adaptive version, translated from Racket #
            PROC quad simpsons mem = ( PROC(REAL)REAL f, REAL a, fa, b, fb )TRIPLE:
                 BEGIN # Evaluates Simpson's Rule, also returning m and f(m) to reuse. #
                    REAL m    = ( a + b ) / 2;
                    REAL fm   = f( m );
                    REAL simp = ABS ( b - a ) / 6 * ( fa + 4*fm + fb );
                    ( m, fm, simp )
                 END # quad simpsons mem # ;

            PROC quad asr rec = ( PROC(REAL)REAL f, REAL a, fa, b, fb, eps, whole, m, fm )REAL:
                 IF # Efficient recursive implementation of adaptive Simpson's rule. #
                    # Function values at the start, middle, end of the intervals are retained. #
                    TRIPLE lt    = quad simpsons mem( f, a, fa, m, fm );
                    TRIPLE rt    = quad simpsons mem( f, m, fm, b, fb );
                    REAL   delta = simp OF lt + simp OF rt - whole;
                    ABS delta <= eps * 15
                 THEN simp OF lt + simp OF rt + delta / 15
                 ELSE quad asr rec( f, a, fa, m, fm, eps / 2, simp OF lt, m OF lt, fm OF lt )
                    + quad asr rec( f, m, fm, b, fb, eps / 2, simp OF rt, m OF rt, fm OF rt )
                 FI # quad asr # ;

             # Integrate f from a to b using ASR with max error of eps. #
             REAL   fa = f( a );
             REAL   fb = f( b );
             TRIPLE t  = quad simpsons mem( f, a, fa, b, fb );
             quad asr rec( f, a, fa, b, fb, eps, simp OF t, m OF t, fm OF t )
         END # quad asr # ;

    REAL a = 0.0, b = 1.0;
    REAL sinx = quad asr( sin, a, b, 1e-09 );
    print( ( "Simpson's integration of sine from ", fixed( a,    -6, 3 )
           , " to ",                                fixed( b,    -6, 3 )
           , " = ",                                 fixed( sinx, -9, 6 )
           , newline
           )
         )
END
