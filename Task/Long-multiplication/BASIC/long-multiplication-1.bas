'PROGRAM : BIG MULTIPLICATION VER #1
'LRCVS 01.01.2010
'THIS PROGRAM SIMPLY MAKES A MULTIPLICATION
'WITH ALL THE PARTIAL PRODUCTS.
'............................................................

DECLARE SUB A.INICIO (A$, B$)
DECLARE SUB B.STORE (CAD$, N$)
DECLARE SUB C.PIZARRA ()
DECLARE SUB D.ENCABEZADOS (A$, B$)
DECLARE SUB E.MULTIPLICACION (A$, B$)
DECLARE SUB G.SUMA ()
DECLARE FUNCTION F.INVCAD$ (CAD$)

RANDOMIZE TIMER
CALL A.INICIO(A$, B$)
CALL B.STORE(A$, "A")
CALL B.STORE(B$, "B")
CALL C.PIZARRA
CALL D.ENCABEZADOS(A$, B$)
CALL E.MULTIPLICACION(A$, B$)
CALL G.SUMA

SUB A.INICIO (A$, B$)
    CLS
'Note: Number of digits > 1000
    INPUT "NUMBER OF DIGITS  "; S
    CLS
    A$ = ""
    B$ = ""
    FOR N = 1 TO S
        A$ = A$ + LTRIM$(STR$(INT(RND * 9)))
    NEXT N
    FOR N = 1 TO S
        B$ = B$ + LTRIM$(STR$(INT(RND * 9)))
    NEXT N
END SUB

SUB B.STORE (CAD$, N$)
    OPEN "O", #1, N$
    FOR M = LEN(CAD$) TO 1 STEP -1
        WRITE #1, MID$(CAD$, M, 1)
    NEXT M
    CLOSE (1)
END SUB

SUB C.PIZARRA
    OPEN "A", #3, "R"
    WRITE #3, ""
    CLOSE (3)
    KILL "R"
END SUB

SUB D.ENCABEZADOS (A$, B$)
    LT = LEN(A$) + LEN(B$) + 1
    L$ = STRING$(LT, " ")
    OPEN "A", #3, "R"
    MID$(L$, LT - LEN(A$) + 1) = A$
    WRITE #3, L$
    CLOSE (3)
    L$ = STRING$(LT, " ")
    OPEN "A", #3, "R"
    MID$(L$, LT - LEN(B$) - 1) = "X " + B$
    WRITE #3, L$
    CLOSE (3)
END SUB

SUB E.MULTIPLICACION (A$, B$)
    LT = LEN(A$) + LEN(B$) + 1
    L$ = STRING$(LT, " ")
    C$ = ""
    D$ = ""
    E$ = ""
    CT1 = 1
    ACUM = 0
    OPEN "I", #2, "B"
    WHILE EOF(2) <> -1
        INPUT #2, B$
        OPEN "I", #1, "A"
        WHILE EOF(1) <> -1
            INPUT #1, A$
            RP = (VAL(A$) * VAL(B$)) + ACUM
            C$ = LTRIM$(STR$(RP))
            IF EOF(1) <> -1 THEN D$ = D$ + RIGHT$(C$, 1)
            IF EOF(1) = -1 THEN D$ = D$ + F.INVCAD$(C$)
            E$ = LEFT$(C$, LEN(C$) - 1)
            ACUM = VAL(E$)
        WEND
        CLOSE (1)
        MID$(L$, LT - CT1 - LEN(D$) + 2) = F.INVCAD$(D$)
        OPEN "A", #3, "R"
        WRITE #3, L$
        CLOSE (3)
        L$ = STRING$(LT, " ")
        ACUM = 0
        C$ = ""
        D$ = ""
        E$ = ""
        CT1 = CT1 + 1
    WEND
    CLOSE (2)
END SUB

FUNCTION F.INVCAD$ (CAD$)
    LCAD = LEN(CAD$)
    CADTEM$ = ""
    FOR CAD = LCAD TO 1 STEP -1
        CADTEM$ = CADTEM$ + MID$(CAD$, CAD, 1)
    NEXT CAD
    F.INVCAD$ = CADTEM$
END FUNCTION

SUB G.SUMA
    CF = 0
    OPEN "I", #3, "R"
    WHILE EOF(3) <> -1
        INPUT #3, R$
        CF = CF + 1
        AN = LEN(R$)
    WEND
    CF = CF - 2
    CLOSE (3)
    W$ = ""
    ST = 0
    ACUS = 0
    FOR P = 1 TO AN
        K = 0
        OPEN "I", #3, "R"
        WHILE EOF(3) <> -1
            INPUT #3, R$
            K = K + 1
            IF K > 2 THEN ST = ST + VAL(MID$(R$, AN - P + 1, 1))
            IF K > 2 THEN M$ = LTRIM$(STR$(ST + ACUS))
        WEND
        'COLOR 10: LOCATE CF + 3, AN - P + 1: PRINT RIGHT$(M$, 1); : COLOR 7
        W$ = W$ + RIGHT$(M$, 1)
        ACUS = VAL(LEFT$(M$, LEN(M$) - 1))
        CLOSE (3)
        ST = 0
    NEXT P

    OPEN "A", #3, "R"
    WRITE #3, " " + RIGHT$(F.INVCAD(W$), AN - 1)
    CLOSE (3)
    CLS
    PRINT "THE SOLUTION IN THE FILE: R"
END SUB
