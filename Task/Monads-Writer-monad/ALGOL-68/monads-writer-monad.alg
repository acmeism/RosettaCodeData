BEGIN
    MODE MWRITER = STRUCT( LONG REAL value
                         , STRING    log
                         );
    PRIO BIND = 9;
    OP   BIND = ( MWRITER m, PROC( LONG REAL )MWRITER f )MWRITER:
    (    MWRITER n := f( value OF m );
         log OF n  := log OF m + log OF n;
         n
    );

    OP   LEN     = ( STRING s )INT: ( UPB s + 1 ) - LWB s;
    PRIO PAD     = 9;
    OP   PAD     = ( STRING s, INT width )STRING: IF LEN s >= width THEN s ELSE s + ( width - LEN s ) * " " FI;

    PROC unit    = ( LONG REAL v, STRING s )MWRITER: ( v, "  " + s PAD 17 + ":" + fixed( v, -19, 15 ) + REPR 10 );

    PROC root    = ( LONG REAL v )MWRITER: unit( long sqrt( v ), "Took square root" );
    PROC add one = ( LONG REAL v )MWRITER: unit( v+1, "Added one" );
    PROC half    = ( LONG REAL v )MWRITER: unit( v/2, "Divided by two" );

    MWRITER mw2 := unit( 5, "Initial value" ) BIND root BIND add one BIND half;
    print( ( "The Golden Ratio is", fixed( value OF mw2, -19, 15 ), newline ) );
    print( ( newline, "This was derived as follows:-", newline ) );
    print( ( log OF mw2 ) )
END
