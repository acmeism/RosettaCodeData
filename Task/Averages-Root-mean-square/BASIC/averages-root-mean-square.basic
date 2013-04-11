DIM i(1 TO 10) AS DOUBLE, L0 AS LONG
FOR L0 = 1 TO 10
    i(L0) = L0
NEXT
PRINT STR$(rms#(i()))

FUNCTION rms# (what() AS DOUBLE)
    DIM L0 AS LONG, tmp AS DOUBLE, rt AS DOUBLE
    FOR L0 = LBOUND(what) TO UBOUND(what)
        rt = rt + (what(L0) ^ 2)
    NEXT
    tmp = UBOUND(what) - LBOUND(what) + 1
    rms# = SQR(rt / tmp)
END FUNCTION
