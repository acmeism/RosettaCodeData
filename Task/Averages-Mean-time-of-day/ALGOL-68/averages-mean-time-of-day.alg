BEGIN # Mean time of day mapping time to angles                      #

    # code from the Averages/Mean angle task - angles are in degrees #
    PROC mean angle = ([]REAL angles)REAL:
    (
      INT size = UPB angles - LWB angles + 1;
      REAL y part := 0, x part := 0;
      FOR i FROM LWB angles TO UPB angles DO
          x part +:= cos (angles[i] * pi / 180);
          y part +:= sin (angles[i] * pi / 180)
      OD;

      arc tan2 (y part / size, x part / size) * 180 / pi
    );
    # end code from the Averages/Mean angle task                     #

    MODE TIME = STRUCT( INT hh, mm, ss );

    OP   TOANGLE = ( TIME t )REAL: ( ( ( ( ( ss OF t / 60 ) + mm OF t ) / 60 ) + hh OF t ) * 360 ) / 24;
    OP   TOTIME  = ( REAL a )TIME:
         BEGIN
            REAL t  := ( a * 24 ) / 360;
            WHILE t <  0 DO t +:= 24 OD;
            WHILE t > 24 DO t -:= 24 OD;
            INT  hh  = ENTIER t;
            t      -:= hh *:= 60;
            INT  mm  = ENTIER t;
            INT  ss  = ENTIER ( ( t - mm ) * 60 );
            ( hh, mm, ss )
         END # TOTIME # ;

    PROC mean time = ( []TIME times )TIME:
         BEGIN
            [ LWB times : UPB times ]REAL angles;
            FOR i FROM LWB times TO UPB times DO angles[ i ] := TOANGLE times[ i ] OD;
            TOTIME mean angle( angles )
         END # mean time # ;

    OP   SHOW = ( TIME t )VOID:
         BEGIN
            PROC d2 = ( INT n )STRING: IF n < 10 THEN "0" ELSE "" FI + whole( n, 0 );
            print( ( d2( hh OF t ), ":", d2( mm OF t ), ":", d2( ss OF t ) ) )
         END # show time # ;

    SHOW mean time( ( ( 23,00,17 ), ( 23,40,20 ), ( 00,12,45 ), ( 00,17,19 ) ) )
END
