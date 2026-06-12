BEGIN % check whether sme numbers are coPrime (their gcd is 1) or not %
    LOGICAL PROCEDURE COPRM ( INTEGER VALUE X, Y ) ; GCD( X, Y ) = 1;
    INTEGER PROCEDURE GCD ( INTEGER VALUE A, B ) ;
    BEGIN
        INTEGER AA, BB;
        AA := A;
        BB := B;
        WHILE AA NOT = BB DO BEGIN
            IF AA > BB THEN AA := AA - BB;
            IF AA < BB THEN BB := BB - AA
        END WHILE_AA_NE_BB  ;
        AA
    END GCD ;
    INTEGER ARRAY P, Q ( 0 :: 4 );
    INTEGER POS;
    POS := 0; FOR I := 21, 17, 36, 18, 60 DO BEGIN P( POS ) := I; POS := POS + 1 END;
    POS := 0; FOR I := 15, 23, 12, 29, 15 DO BEGIN Q( POS ) := I; POS := POS + 1 END;
    WRITE( "COPRIMES" );
    FOR I := 0 UNTIL 4 DO BEGIN
        INTEGER PP, QQ;
        PP := P( I );
        QQ := Q( I );
        IF COPRM( PP, QQ ) THEN WRITE( I_W := 4, S_W := 0, PP, QQ )
    END FOR_I
END.
