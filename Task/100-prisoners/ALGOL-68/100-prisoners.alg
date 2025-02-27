BEGIN # 100 prisoners                                                        #

CO  begin code from the Knuth shuffle task                                  CO
PROC between = (INT a, b)INT :
(
  ENTIER (random * ABS (b-a+1) + (a<b|a|b))
);

PROC knuth shuffle = (REF[]INT a)VOID:
(
  FOR i FROM LWB a TO UPB a DO
    INT j = between(LWB a, UPB a);
    INT t = a[i];
    a[i] := a[j];
    a[j] := t
  OD
);
CO  end   code from the Knuth shuffle task                                  CO

    INT number of prisoners = 100;

    # tries to find the prisoners' numbers in the drawers, choosing drawers  #
    #       by the optimal strategy if `use optimal strategy` is TRUE or     #
    #       at random otherwise; returns TRUE if alll prisoners were found   #
    #       FALSE otherwise                                                  #
    PROC try drawers = ( BOOL use optimal strategy, REF[]INT drawers )BOOL:
         BEGIN
            BOOL found := TRUE;
            [ LWB drawers : UPB drawers ]BOOL tried;
            FOR prisoner TO number of prisoners WHILE found DO
                FOR i FROM LWB drawers TO UPB drawers DO tried[ i ] := FALSE OD;
                found := FALSE;
                INT  drawer to try := IF   use optimal strategy
                                      THEN prisoner
                                      ELSE between( LWB drawers, UPB drawers )
                                      FI;
                TO 50 WHILE NOT ( found := prisoner = drawers[ drawer to try ] ) DO
                    tried[ drawer to try ] := TRUE;
                    IF use optimal strategy THEN
                        drawer to try := drawers[ drawer to try ]
                    ELSE
                        WHILE tried[ drawer to try ] DO
                            drawer to try := between( LWB drawers, UPB drawers )
                        OD
                    FI
                OD
            OD;
            found
         END # try drawers # ;

    BEGIN # run the random and optimal strategies and compare the successes  #
        INT tests         = 10 000;  # number of times to try the strategies #
        INT random count := 0, optimal count := 0;
        [ 1 : 100 ]INT drawers;
        TO tests DO
            FOR i FROM LWB drawers TO UPB drawers DO drawers[ i ] := i OD;
            knuth shuffle( drawers );
            IF try drawers( FALSE, drawers ) THEN random count  +:= 1 FI;
            IF try drawers( TRUE,  drawers ) THEN optimal count +:= 1 FI
        OD;
        print( ( "100 prisoners: success rate via  random choice: " ) );
        print( ( fixed( ( random count  * 100 ) / tests, - 6, 2 ), "%", newline ) );
        print( ( "               success rate via optimal choice: " ) );
        print( ( fixed( ( optimal count * 100 ) / tests, - 6, 2 ), "%", newline ) )
    END
END
