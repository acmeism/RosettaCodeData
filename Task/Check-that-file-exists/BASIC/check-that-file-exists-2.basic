ON ERROR GOTO ohNo
d$ = "docs"
CHDIR d$
d$ = "\docs"
CHDIR d$
END

ohNo:
    IF 76 = ERR THEN
        PRINT d$; " not found"
    ELSE
        PRINT "Unknown error"
    END IF
    RESUME NEXT
