DECLARE FUNCTION median! (vector() AS SINGLE)

DIM vec1(10) AS SINGLE, vec2(11) AS SINGLE, n AS INTEGER

RANDOMIZE TIMER

FOR n = 0 TO 10
    vec1(n) = RND * 100
    vec2(n) = RND * 100
NEXT
vec2(11) = RND * 100

PRINT median(vec1())
PRINT median(vec2())

FUNCTION median! (vector() AS SINGLE)
    DIM lb AS INTEGER, ub AS INTEGER, L0 AS INTEGER
    lb = LBOUND(vector)
    ub = UBOUND(vector)
    REDIM v(lb TO ub) AS SINGLE
    FOR L0 = lb TO ub
        v(L0) = vector(L0)
    NEXT
    quicksort v(), lb, ub
    IF ((ub - lb + 1) MOD 2) THEN
        median = v((ub + lb) / 2)
    ELSE
        median = (v(INT((ub + lb) / 2)) + v(INT((ub + lb) / 2) + 1)) / 2
    END IF
END FUNCTION
