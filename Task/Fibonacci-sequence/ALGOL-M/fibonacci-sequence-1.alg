INTEGER FUNCTION FIBONACCI( X ); INTEGER X;
BEGIN
    INTEGER M, N, A, I;
    M := 0;
    N := 1;
    FOR I := 2 STEP 1 UNTIL X DO
    BEGIN
        A := N;
        N := M + N;
        M := A;
    END;
    FIBONACCI := N;
END;
