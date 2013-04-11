DECLARE FUNCTION f! (n!)
DECLARE FUNCTION m! (n!)

FUNCTION f! (n!)
    IF n = 0 THEN
        f = 1
    ELSE
        f = m(f(n - 1))
    END IF
END FUNCTION

FUNCTION m! (n!)
    IF n = 0 THEN
        m = 0
    ELSE
        m = f(m(n - 1))
    END IF
END FUNCTION
