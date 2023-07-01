ON ERROR GOTO ohNo
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
    e$ = " found"
    OPEN f$ FOR INPUT AS 1
    PRINT f$; e$
    CLOSE
    RETURN

ohNo:
    IF (53 = ERR) OR (76 = ERR) THEN
        e$ = " not" + e$
    ELSE
        e$ = "Unknown error"
    END IF
    RESUME NEXT
