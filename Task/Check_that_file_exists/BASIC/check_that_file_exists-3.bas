f$ = "input.txt"
GOSUB opener
f$ = "\input.txt"
GOSUB opener

'can't directly check for directories,
'but can check for the NUL device in the desired dir
f$ = "docs\nul"
GOSUB opener
f$ = "\docs\nul"
GOSUB opener
END

opener:
    d$ = DIR$(f$)
    IF LEN(d$) THEN
        PRINT f$; " found"
    ELSE
        PRINT f$; " not found"
    END IF
    RETURN
