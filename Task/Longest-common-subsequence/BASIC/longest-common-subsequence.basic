FUNCTION lcs$ (a$, b$)
    IF LEN(a$) = 0 OR LEN(b$) = 0 THEN
	lcs$ = ""
    ELSEIF RIGHT$(a$, 1) = RIGHT$(b$, 1) THEN
	lcs$ = lcs$(LEFT$(a$, LEN(a$) - 1), LEFT$(b$, LEN(b$) - 1)) + RIGHT$(a$, 1)
    ELSE
	x$ = lcs$(a$, LEFT$(b$, LEN(b$) - 1))
	y$ = lcs$(LEFT$(a$, LEN(a$) - 1), b$)
	IF LEN(x$) > LEN(y$) THEN
		lcs$ = x$
	ELSE
		lcs$ = y$
	END IF
    END IF
END FUNCTION
