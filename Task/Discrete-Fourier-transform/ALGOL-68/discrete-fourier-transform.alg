BEGIN # descrete Fourier transform - translated from the FreeBasic sample #

    PROC dft = ( []COMPL x )[]COMPL:
         BEGIN
            INT k = ( UPB x - LWB x ) + 1;
            [ LWB x : UPB x ]COMPL y;
            FOR i FROM LWB x TO UPB x DO
                y[ i ] := 0;
                INT i0 = i - LWB y;
                FOR j FROM LWB x TO UPB x DO
                    INT j0   = j - LWB y;
                    COMPL t  = ( 0, -2 * pi * i0 * j0 / k );
                    y[ i ] +:= x[ j ] * complex exp( t )
                OD
            OD;
            y
         END # dft # ;

    PROC idft = ( []COMPL y )[]REAL:
         BEGIN
            INT k = ( UPB y - LWB y ) + 1;
            [ LWB y : UPB y ]COMPL x;
            FOR j FROM LWB x TO UPB x DO
                x[ j ] := 0;
                INT j0  = j - LWB x;
                FOR i FROM LWB x TO UPB x DO
                    INT i0 = i - LWB x;
                    COMPL t  = ( 0, 2 * pi * i0 * j0 / k );
                    x[ j ] +:= y[ i ] * complex exp( t )
                OD;
                re OF x[ j ] /:= k;
                im OF x[ j ] /:= k;
                # clean x(j) to remove very small imaginary values #
                IF ABS im OF x[ j ] < 1e-14 THEN im OF x[ j ] := 0 FI
            OD;
            [ LWB x : UPB x ]REAL z;
            FOR j FROM LWB z TO UPB z DO
                z[ j ] := re OF x[ j ]
            OD;
            z
         END # idft # ;

    BEGIN

        # returns v formatted with dp decimal places and an explicit sign #
        #         if dp is positive or a sign only if v is negative       #
        #         if d[ is negative                                       #
        PRIO FMT = 9;
        OP   FMT = ( REAL v, INT dp )STRING:
             BEGIN
                STRING result = IF ENTIER v = v
                                THEN whole( v, SIGN dp * 16 )
                                ELSE fixed( v, SIGN dp * 16, ABS dp )
                                FI;
                INT v pos := LWB result;
                WHILE result[ v pos ] = " " DO v pos +:= 1 OD;
                result[ v pos : ]
             END # FMT # ;

        []REAL z = ( 2, 3, 5, 7, 11 );
        [ LWB z : UPB z ]COMPL x;
        print( ( newline, "Original sequence: [" ) );
        FOR i FROM LWB z TO UPB z DO
            x[ i ] := z[ i ];
            print( ( whole( z[ i ], 0 ), IF i < UPB z THEN ", " ELSE "" FI ) )
        OD;
        print( ( "]", newline ) );

        []COMPL y = dft( x );
        print( ( newline, "After applying the Discrete Fourier Transform: ", newline, "[" ) );
        FOR i FROM LWB y TO UPB y DO
            print( ( re OF y[ i ] FMT -4 ) );
            IF im OF y[ i ] /= 0 THEN
                print( ( im OF y[ i ] FMT 4, "i" ) )
            FI;
            IF i < UPB y THEN print( ( ", " ) ) FI
        OD;
        print( ( "]", newline ) );

        []REAL z2 = idft( y );
        print( ( newline, "After applying the Inverse Discrete Fourier Transform " ) );
        print( ( "to the above transform: ", newline, "[" ) );
        FOR i FROM LWB z2 TO UPB z2 DO
            print( ( whole( z2[ i ], 0 ), IF i < UPB z2 THEN ", " ELSE "" FI ) )
        OD;
        print( ( "]", newline ) )

    END

END
