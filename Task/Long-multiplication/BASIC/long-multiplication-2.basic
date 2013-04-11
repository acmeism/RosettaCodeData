'PROGRAM: BIG MULTIPLICATION VER # 2
'LRCVS 01/01/2010
'THIS PROGRAM SIMPLY MAKES A BIG MULTIPLICATION
'WITHOUT THE PARTIAL PRODUCTS.
'HERE SEE ONLY THE SOLUTION.
'...............................................................
CLS
PRINT "WAIT"

NA = 2000 'NUMBER OF ELEMENTS OF THE MULTIPLY.
NB = 2000  'NUMBER OF ELEMENTS OF THE MULTIPLIER.
'Solution = 4000 Exacts digits

'......................................................
OPEN "X" + ".MLT" FOR BINARY AS #1
CLOSE (1)
KILL "*.MLT"
'.....................................................
'CREATING THE MULTIPLY  >>> A
'CREATING THE MULTIPLIER >>> B
FOR N = 1 TO 2
IF N = 1 THEN F$ = "A" + ".MLT": NN = NA
IF N = 2 THEN F$ = "B" + ".MLT": NN = NB
    OPEN F$ FOR BINARY AS #1
        FOR N2 = 1 TO NN
            RANDOMIZE TIMER
            X$ = LTRIM$(STR$(INT(RND * 10)))
            SEEK #1, N2: PUT #1, N2, X$
        NEXT N2
    SEEK #1, N2
    CLOSE (1)
NEXT N
'.....................................................
OPEN "A" + ".MLT" FOR BINARY AS #1
FOR K = 0 TO 9
NUM$ = "": Z$ = "": ACU = 0: GG = NA
C$ = LTRIM$(STR$(K))
    OPEN C$ + ".MLT" FOR BINARY AS #2
        'OPEN "A" + ".MLT" FOR BINARY AS #1
            FOR N = 1 TO NA
                SEEK #1, GG: GET #1, GG, X$
                NUM$ = X$
                Z$ = LTRIM$(STR$(ACU + (VAL(X$) * VAL(C$))))
                L = LEN(Z$)
                ACU = 0
                IF L = 1 THEN NUM$ = Z$: PUT #2, N, NUM$
                IF L > 1 THEN ACU = VAL(LEFT$(Z$, LEN(Z$) - 1)): NUM$ = RIGHT$(Z$, 1): PUT #2, N, NUM$
                SEEK #2, N: PUT #2, N, NUM$
                GG = GG - 1
            NEXT N
        IF L > 1 THEN ACU = VAL(LEFT$(Z$, LEN(Z$) - 1)): NUM$ = LTRIM$(STR$(ACU)): XX$ = XX$ + NUM$: PUT #2, N, NUM$
        'CLOSE (1)
    CLOSE (2)
NEXT K
CLOSE (1)
'......................................................
ACU = 0
LT5 = 1
LT6 = LT5
OPEN "B" + ".MLT" FOR BINARY AS #1
    OPEN "D" + ".MLT" FOR BINARY AS #3
        FOR JB = NB TO 1 STEP -1
        SEEK #1, JB
        GET #1, JB, X$

            OPEN X$ + ".MLT" FOR BINARY AS #2: LF = LOF(2): CLOSE (2)

            OPEN X$ + ".MLT" FOR BINARY AS #2
                FOR KB = 1 TO LF
                    SEEK #2, KB
                    GET #2, , NUM$
                    SEEK #3, LT5
                    GET #3, LT5, PR$
                    T$ = ""
                    T$ = LTRIM$(STR$(ACU + VAL(NUM$) + VAL(PR$)))
                    PR$ = RIGHT$(T$, 1)
                    ACU = 0
                    IF LEN(T$) > 1 THEN ACU = VAL(LEFT$(T$, LEN(T$) - 1))
                    SEEK #3, LT5: PUT #3, LT5, PR$
                    LT5 = LT5 + 1
                NEXT KB
                IF ACU <> 0 THEN PR$ = LTRIM$(STR$(ACU)): PUT #3, LT5, PR$
            CLOSE (2)
        LT6 = LT6 + 1
        LT5 = LT6
        ACU = 0
        NEXT JB
    CLOSE (3)
CLOSE (1)
OPEN "D" + ".MLT" FOR BINARY AS #3: LD = LOF(3): CLOSE (3)
ER = 1
OPEN "D" + ".MLT" FOR BINARY AS #3
    OPEN "R" + ".MLT" FOR BINARY AS #4
        FOR N = LD TO 1 STEP -1
            SEEK #3, N: GET #3, N, PR$
            SEEK #4, ER: PUT #4, ER, PR$
            ER = ER + 1
        NEXT N
    CLOSE (4)
CLOSE (3)
KILL "D.MLT"
FOR N = 0 TO 9
    C$ = LTRIM$(STR$(N))
    KILL C$ + ".MLT"
NEXT N
PRINT "END"
PRINT "THE SOLUTION IN THE FILE: R.MLT"
