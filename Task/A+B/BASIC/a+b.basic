DEFINT A-Z

tryagain:
backhere = CSRLIN
INPUT "", i$
i$ = LTRIM$(RTRIM$(i$))
where = INSTR(i$, " ")
IF where THEN
    a = VAL(LEFT$(i$, where - 1))
    b = VAL(MID$(i$, where + 1))
    c = a + b
    LOCATE backhere, LEN(i$) + 1
    PRINT c
ELSE
    GOTO tryagain
END IF
