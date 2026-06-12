BEGIN # NKTg Law in Earth orbit - translation of Rust via Pluto #

    REAL dm dt       = -1.8;  # kg/s #

    OP   LEN         = ( STRING s )INT: 1 + UPB s - LWB s;
    PRIO PAD         = 9;
    OP   PAD         = ( STRING s, INT w )STRING:
                       IF INT l = LEN s; l >= w THEN s ELSE s + ( ( w - l ) * " " ) FI;
    OP   PAD         = ( INT w, STRING s )STRING:
                       IF INT l = LEN s; l >= w THEN s ELSE ( ( w - l ) * " " ) + s FI;

    MODE ORBITALDATA = STRUCT( STRING date, REAL x, v, m );
    MODE RESULTROW   = STRUCT( STRING date
                             , REAL p, nktg1, nktg2, v sim, v nasa, err
                             );
    MODE OBSERVATION = STRUCT( STRING date, REAL v );
    OP   TOSTRING    = ( RESULTROW r )STRING:
                                       date OF r PAD 12       + " "
                     + 14 PAD float(      p OF r, -10, 3, 3 ) + " "
                     + 14 PAD float(  nktg1 OF r, -10, 3, 3 ) + " "
                     + 14 PAD float(  nktg2 OF r, -10, 3, 3 ) + " "
                     + 12 PAD float(  v sim OF r, -10, 3, 3 ) + " "
                     + 12 PAD float( v nasa OF r, -10, 3, 3 ) + " "
                     +        fixed(    err OF r, -10, 4    ) + "%"
                     ;
    PROC momentum    = ( REAL m, v )REAL: m * v;
    PROC nktg1       = ( REAL x, p )REAL: x * p;
    PROC nktg2       = ( REAL    p )REAL: dm dt * p;
    PROC relative error = ( REAL sim, nasa )REAL: ( sim - nasa ) / nasa * 100;

    # Simulated NKTg 2025 dataset. #
    []ORBITALDATA sim 2025
                = ( ( "01/01/2025", 1.471012e11, 3.0276e4, 5.97219e24 )
                  , ( "04/01/2025", 1.494953e11, 2.9791e4, 5.97218999999998e24 )
                  , ( "07/01/2025", 1.520965e11, 2.9282e4, 5.97218999999997e24 )
                  , ( "10/01/2025", 1.496328e11, 2.9764e4, 5.97218999999995e24 )
                  , ( "12/31/2025", 1.471025e11, 3.0276e4, 5.97218999999994e24 )
                  );

    # NASA observed velocities. #
    []OBSERVATION nasa 2025
                = ( ( "01/01/2025", 3.0287e4 )
                  , ( "04/01/2025", 2.9791e4 )
                  , ( "07/01/2025", 2.9291e4 )
                  , ( "10/01/2025", 2.9778e4 )
                  , ( "12/31/2025", 3.0286e4 )
                  );

    print( ( newline, "Experimental Verification of NKTg Law (Earth 2025)", newline, newline ) );
    print( ( "Date" PAD 12 ) );
    print( ( " " + 14 PAD "Momentum(p)" + " " + 14 PAD "NKTg1"  + " " + 14 PAD "NKTg2" ) );
    print( ( " " + 12 PAD "v_sim"       + " " + 12 PAD "v_NASA" + " " + 10 PAD "Error", newline ) );
    print( ( "-" * 95, newline ) );

    FOR i FROM  LWB sim 2025 TO UPB sim 2025 DO
        ORBITALDATA data = sim 2025[ i ];
        IF date OF data /= date OF nasa 2025[ i ] THEN
            print( ( "**** Date mismatch on observation/simulation ", whole( i, 0 ), newline ) )
        ELSE
            REAL p      = momentum( m OF data, v OF data );
            REAL n1     = nktg1( x OF data, p );
            REAL n2     = nktg2( p );
            REAL v sim  = v OF data;
            REAL v nasa = v OF nasa 2025[ i ];
            REAL err    = relative error( v OF data, v nasa );
            print( ( TOSTRING RESULTROW( date OF data, p, n1, n2, v sim, v nasa, err ), newline ) )
        FI
    OD

END
