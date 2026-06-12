BEGIN # product of divisors - transaltion of the Fortran sample #
    [ 1 : 50 ]INT divis;
    FOR i TO UPB divis DO divis[ i ] := 1 OD;
    FOR i FROM 2 TO UPB divis DO
        FOR j FROM i BY i TO UPB divis DO
            divis[ j ] *:= i
        OD
    OD;
    FOR i TO UPB divis DO
        print( ( whole( divis[ i ], -10 ) ) );
        IF i MOD 5 = 0 THEN print( ( newline ) ) FI
    OD
END
