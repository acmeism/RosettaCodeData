BEGIN # Diversity Prediction Theorem                                         #

    # utility operators                                                      #
    OP   LENGTH = ( []REAL a )INT: ( UPB a - LWB a ) + 1;
    OP   LENGTH = ( STRING a )INT: ( UPB a - LWB a ) + 1;
    OP   SUM    = ( []REAL a )REAL:
         BEGIN
            REAL result := 0;
            FOR i FROM LWB a TO UPB a DO result +:= a[ i ] OD;
            result
         END # SUM # ;
    PRIO PAD    = 9;
    OP   PAD    = ( INT width, STRING v )STRING: # left blank pad v to width #
         IF LENGTH v >= width THEN v ELSE ( " " * ( width - LENGTH v ) ) + v FI;
    OP   - = ( []REAL a, REAL v )[]REAL:        # return a with elements - v #
         BEGIN
            [ LWB a : UPB a ]REAL result;
            FOR i FROM LWB a TO UPB a DO result[ i ] := v - a[ i ] OD;
            result
         END # - # ;
    OP   ^ = ( []REAL a, INT p )[]REAL: # return a with elements raised to p #
         BEGIN
            [ LWB a : UPB a ]REAL result;
            FOR i FROM LWB a TO UPB a DO result[ i ] := a[ i ] ^ p OD;
            result
         END # |^ # ;
    PRIO FMT = 1;
    OP   FMT = ( REAL v, INT d )STRING:   # formats v with up to d decimals  #
         BEGIN
            STRING result := fixed( v, -0, d );
            IF result[ LWB result ] = "." THEN "0" +=: result FI;
            WHILE result[ UPB result ] = "0" DO result := result[ : UPB result - 1 ] OD;
            IF result[ UPB result ] = "." THEN result := result[ : UPB result - 1 ] FI;
            " " + result
         END # FMT # ;

    # task                                                                   #

    MODE NAMEDVALUE = STRUCT( STRING name, REAL value );

    PROC mean = ( []REAL s )REAL: SUM s / LENGTH s;

    PROC variance = ( []REAL s, REAL d )REAL: mean( ( s - d ) ^ 2 );

    PROC diversity theorem = ( REAL reference, []REAL observations )[]NAMEDVALUE:
         BEGIN
            REAL average = mean( observations );
            ( ( "average_error", variance( observations, reference ) )
            , ( "crowd_error",   ( reference - average ) ^ 2         )
            , ( "diversity",     variance( observations, average   ) )
            )
         END # diversity theorem # ;

    PROC test = ( REAL reference, []REAL observations )VOID:
         BEGIN
            []NAMEDVALUE res = diversity theorem( reference, observations );
            FOR i FROM LWB res TO UPB res DO
                print( ( 14 PAD name OF res[ i ], " : ", value OF res[ i ] FMT 6, newline ) )
            OD
         END # test # ;

    test( 49, ( 48, 47, 51     ) );
    test( 49, ( 48, 47, 51, 42 ) )

END
