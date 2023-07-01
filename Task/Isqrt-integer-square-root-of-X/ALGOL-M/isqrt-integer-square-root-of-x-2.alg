% RETURN INTEGER SQUARE ROOT OF N %
INTEGER FUNCTION ISQRT(N);
INTEGER N;
BEGIN
    INTEGER R1, R2;
    R1 := N;
    R2 := 1;
    WHILE R1 > R2 DO
        BEGIN
            R1 := (R1+R2) / 2;
            R2 := N / R1;
        END;
    ISQRT := R1;
END;
