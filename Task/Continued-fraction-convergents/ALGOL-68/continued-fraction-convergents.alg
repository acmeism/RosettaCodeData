BEGIN # Continued fraction convergents task, translated from the EasyLang sample #

    PRIO =:= = 1;
    OP   =:= = ( REF INT a, b )VOID: BEGIN INT t = a; a := b; b := t END;

    PROC convergents = ( REAL x in, INT maxcomp )[]STRING: BEGIN
         REAL eps = 1e-9; REAL x := x in;
         [ 1 : maxcomp ]INT comps; INT clen := 0;
         FOR i FROM LWB comps TO UPB comps DO comps[ i ] := 0 OD;
         FOR i FROM LWB comps TO UPB comps WHILE INT  ipart = ENTIER x;
                                                 REAL fpart = x - ipart;
                                                 comps[ clen +:= 1 ] := ipart;
                                                 ABS fpart >= eps
         DO
             x := 1 / fpart
         OD;
         INT numa := 0, denoma := 1, numb := 1, denomb := 0;
         [ 1 : clen ]STRING r; INT rpos := 0;
         FOR c FROM LWB comps TO clen DO
             INT comp := comps[ c ];
             numa    =:= numb;
             denoma  =:= denomb;
             numb    +:= comp * numa;
             denomb  +:= comp * denoma;
             r[ rpos +:= 1 ] := IF denomb = 1 THEN
                                    whole( numb, 0 )
                                ELSE
                                    whole( numb, 0 ) + "/" + whole( denomb, 0 )
                                FI
         OD;
         r
    END;

    PROC test = ( STRING s, REAL n )VOID: BEGIN
         print( ( s, " = " ) );
         []STRING r = convergents( n, 8 );
         FOR rpos FROM LWB r TO UPB r DO print( ( r[ rpos ], " " ) ) OD;
         print( ( newline ) )
    END;

    test( "      415/93", 415 / 93 );
    test( "     649/200", 649 / 200 );
    test( "     sqrt(2)", sqrt( 2 ) );
    test( "     sqrt(5)", sqrt( 5 ) );
    test( "golden ratio", ( sqrt( 5 ) + 1 ) / 2 )
END
