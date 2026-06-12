BEGIN
    INTEGER PROCEDURE BITSP ( INTEGER VALUE BT ) ;
    BEGIN
        INTEGER BITN, BITRSL, BITIDX;
        BITN   := BT;
        BITRSL := 0;
        BITIDX := 1;
        WHILE BITN > 0 DO BEGIN
            INTEGER BITNX;
            BITNX  := BITN DIV 2;
            BITRSL := BITRSL + BITIDX*(BITN-BITNX*2);
            BITN   := BITNX;
            BITIDX := BITIDX*10
        END;
        BITRSL
    END BITSP ;

    INTEGER PROCEDURE DPLBIT ( INTEGER VALUE DVAL ) ;
    BEGIN
        INTEGER DTEMP, DSHFT;
        DTEMP := DVAL;
        DSHFT := DVAL;
        WHILE DTEMP > 0 DO BEGIN
            DSHFT := DSHFT  *  2;
            DTEMP := DTEMP DIV 2;
        END;
        DSHFT + DVAL
    END DPLBIT ;

    BEGIN
        INTEGER N;
        N := 0;
        WHILE BEGIN
              N := N + 1;
              DPLBIT(N) < 1000
        END DO WRITE( S_W := 0, I_W := 3, DPLBIT(N), ": ", I_W := 10, BITSP(DPLBIT(N)) )
    END
END.
