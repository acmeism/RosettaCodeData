DECLARE FUNCTION powL& (x AS INTEGER, y AS INTEGER)
DECLARE FUNCTION powS# (x AS SINGLE, y AS INTEGER)

DIM x AS INTEGER, y AS INTEGER
DIM a AS SINGLE

RANDOMIZE TIMER
a = RND * 10
x = INT(RND * 10)
y = INT(RND * 10)
PRINT x, y, powL&(x, y)
PRINT a, y, powS#(a, y)

FUNCTION powL& (x AS INTEGER, y AS INTEGER)
    DIM n AS INTEGER, m AS LONG
    IF x <> 0 THEN
        m = 1
        IF SGN(y) > 0 THEN
            FOR n = 1 TO y
                m = m * x
            NEXT
        END IF
    END IF
    powL& = m
END FUNCTION

FUNCTION powS# (x AS SINGLE, y AS INTEGER)
    DIM n AS INTEGER, m AS DOUBLE
    IF x <> 0 THEN
        m = 1
        IF y <> 0 THEN
            FOR n = 1 TO y
                m = m * x
            NEXT
            IF y < 0 THEN m = 1# / m
        END IF
    END IF
    powS# = m
END FUNCTION
