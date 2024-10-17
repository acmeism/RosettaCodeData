# mode to hold details of a Heronian triangle #
MODE HERONIAN = STRUCT( INT a, b, c, area, perimeter );
# returns the details of the Heronian Triangle with sides a, b, c or nil if it isn't one #
PROC try ht = ( INT a, b, c )REF HERONIAN:
    BEGIN
        REF HERONIAN    t := NIL;
        REAL            s  = ( a + b + c ) / 2;
        REAL area squared  = s * ( s - a ) * ( s - b ) * ( s - c );
        IF area squared > 0 THEN
            # a, b, c does form a triangle #
            REAL area      = sqrt( area squared );
            IF ENTIER area = area THEN
                # the area is integral so the triangle is Heronian #
                t := HEAP HERONIAN := ( a, b, c, ENTIER area, a + b + c )
            FI
        FI;
        t
    END # try ht # ;
# returns the GCD of a and b #
PROC gcd = ( INT a, b )INT: IF b = 0 THEN a ELSE gcd( b, a MOD b ) FI;
# prints the details of the Heronian triangle t #
PROC ht print = ( REF HERONIAN t )VOID:
     print( ( whole( a OF t, -4 ), whole( b OF t, -5 ), whole( c OF t, -5 ), whole( area OF t, -5 ), whole( perimeter OF t, -10 ), newline ) );
# prints headings for the Heronian Triangle table #
PROC ht title = VOID: print( ( "   a    b    c area perimeter", newline, "---- ---- ---- ---- ---------", newline ) );

BEGIN
    # construct ht as a table of the Heronian Triangles with sides up to 200 #
    [ 1 : 1000 ]REF HERONIAN ht;
    REF HERONIAN             t;
    INT                      ht count := 0;

    FOR c TO 200 DO
        FOR b TO c DO
            FOR a TO b DO
                IF NOT ODD ( a + b + c ) THEN
                    IF gcd( gcd( a, b ), c ) = 1 THEN
                        t := try ht( a, b, c );
                        IF REF HERONIAN(t) ISNT REF HERONIAN(NIL) THEN
                            ht[ ht count +:= 1 ] := t
                        FI
                    FI
                FI
            OD
        OD
    OD;

    # sort the table on ascending area, perimeter and max side length #
    # note we constructed the triangles with c as the longest side    #
    BEGIN
        INT   lower := 1, upper := ht count;
        WHILE upper        := upper - 1;
              BOOL swapped := FALSE;
              FOR i FROM lower TO upper DO
                  REF HERONIAN h := ht[ i     ];
                  REF HERONIAN k := ht[ i + 1 ];
                  IF area OF k < area OF h OR (   area OF k =  area OF h
                                              AND (  perimeter OF k <  perimeter OF h
                                                  OR (   perimeter OF k = perimeter OF h
                                                     AND c OF k < c OF h
                                                     )
                                                  )
                                              )
                  THEN
                      ht[ i     ] := k;
                      ht[ i + 1 ] := h;
                      swapped     := TRUE
                  FI
              OD;
              swapped
        DO SKIP OD;

        # display the triangles #
        print( ( "There are ", whole( ht count, 0 ), " Heronian triangles with sides up to 200", newline ) );
        ht title;
        FOR ht pos TO 10 DO ht print( ht( ht pos ) ) OD;
        print( ( " ...", newline ) );
        print( ( "Heronian triangles with area 210:", newline ) );
        ht title;
        FOR ht pos TO ht count DO
            REF HERONIAN tr := ht[ ht pos ];
            IF area OF tr = 210 THEN ht print( tr ) FI
        OD
    END
END
