BEGIN # solve the SEND+MORE=MONEY puzzle - translation of the Julia sample #
  INT m = 1;
  OP C = ( INT n )CHAR: REPR ( ABS "0" + n ); # convert integer to a digit #
  FOR s FROM 8 TO 9 DO
    FOR e FROM 0 TO 9 DO
      IF e /= m AND e/= s THEN
        FOR n FROM 0 TO 9 DO
          IF n /= m AND n /= s AND n /= e THEN
            FOR d FROM 0 TO 9 DO
              IF d /= m AND d /= s AND d /= e AND d /= n THEN
                FOR o FROM 0 TO 9 DO
                  IF o /= m AND o /= s AND o /= e AND o /= n AND o /= d THEN
                    FOR r FROM 0 TO 9 DO
                      IF r /= m AND r /= s AND r /= e AND r /= n AND r /= d AND r /= o THEN
                        FOR y FROM 0 TO 9 DO
                          IF y /= m AND y /= s AND y /= e AND y /= n AND y /= d AND y /= o AND y /= r THEN
                            IF ( 1000 * ( s + m ) ) + ( 100 * ( e + o ) ) + ( 10 * ( n + r ) ) + ( d + e )
                             = ( 10 000 * m ) + ( 1000 * o ) + ( 100 * n ) + ( 10 * e ) + y
                            THEN
                              print( ( C s, C e, C n, C d, " + ", C m, C o, C r, C e, " = ", C m, C o, C n, C e, C y
                                     )
                                   )
                            FI
                          FI
                        OD
                      FI
                    OD
                  FI
                OD
              FI
            OD
          FI
        OD
      FI
    OD
  OD
END
