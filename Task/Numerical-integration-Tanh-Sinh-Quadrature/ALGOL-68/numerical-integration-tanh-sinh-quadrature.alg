BEGIN # Numerical integration/Tanh-Sinh Quadrature - from the pseudo-code   #

CO  # uncomment these procedurez if your implementation doesn't have sinh, cosh and tanh #
    PROC cosh = ( REAL x )REAL: ( exp( x ) + exp( - x ) ) / 2;
    PROC sinh = ( REAL x )REAL: ( exp( x ) - exp( - x ) ) / 2;
    PROC tanh = ( REAL x )REAL: sinh( x ) / cosh( x );
CO

    PROC tanh sinh = ( PROC(REAL)REAL func, REAL lower, upper, INT steps, REAL acc )REAL:
         BEGIN
            REAL half pi = pi / 2;
            REAL h  := 0.1;
            REAL h0  = ( upper - lower ) / 2, h1 = ( lower + upper ) / 2;
            REAL rr := 0;
            REAL ro := rr + 1 + ( 2 * acc ); # ensure ro is not < acc initially #
            INT  nk := 1;
            TO steps WHILE ABS ( rr - ro ) >= acc DO
                ro      := rr;
                INT  n   = ( nk *:= 2 ) - 1;
                REAL ss := 0;
                FOR i FROM - n TO n DO
                    REAL t  = i * h;
                    REAL sh = sinh( t ), ch = cosh( t );
                    REAL th = tanh( sh * half pi );
                    REAL dx = ( ch * half pi ) / ( cosh( sh * half pi ) ^ 2 );
                    ss +:= func( h1 + h0 * th ) * h * dx
                OD;
                rr := h0 * ss
            OD;
            rr
         END # tanh sinh # ;

    print( ( fixed( tanh sinh( exp, -3, 3, 5, 1e-8 ), -12, 7 ), newline ) )

END
