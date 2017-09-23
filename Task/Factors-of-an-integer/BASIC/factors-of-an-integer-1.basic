DECLARE SUB factor (what AS INTEGER)

REDIM SHARED factors(0) AS INTEGER

DIM i AS INTEGER, L AS INTEGER

INPUT "Gimme a number"; i

factor i

PRINT factors(0);
FOR L = 1 TO UBOUND(factors)
    PRINT ","; factors(L);
NEXT
PRINT

SUB factor (what AS INTEGER)
    DIM tmpint1 AS INTEGER
    DIM L0 AS INTEGER, L1 AS INTEGER

    REDIM tmp(0) AS INTEGER
    REDIM factors(0) AS INTEGER
    factors(0) = 1

    FOR L0 = 2 TO what
        IF (0 = (what MOD L0)) THEN
            'all this REDIMing and copying can be replaced with:
            'REDIM PRESERVE factors(UBOUND(factors)+1)
            'in languages that support the PRESERVE keyword
            REDIM tmp(UBOUND(factors)) AS INTEGER
            FOR L1 = 0 TO UBOUND(factors)
                tmp(L1) = factors(L1)
            NEXT
            REDIM factors(UBOUND(factors) + 1)
            FOR L1 = 0 TO UBOUND(factors) - 1
                factors(L1) = tmp(L1)
            NEXT
            factors(UBOUND(factors)) = L0
        END IF
    NEXT
END SUB
