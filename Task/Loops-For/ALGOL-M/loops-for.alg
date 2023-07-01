BEGIN
    INTEGER I, J;
    FOR I := 1 STEP 1 UNTIL 5 DO
    BEGIN
        WRITE( "" );
        FOR J := 1 STEP 1 UNTIL I DO
            WRITEON( "*" );
    END;
END
