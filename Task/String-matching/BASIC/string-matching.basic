first$ = "qwertyuiop"

'Determining if the first string starts with second string
second$ = "qwerty"
IF LEFT$(first$, LEN(second$)) = second$ THEN
    PRINT "'"; first$; "' starts with '"; second$; "'"
ELSE
    PRINT "'"; first$; "' does not start with '"; second$; "'"
END IF

'Determining if the first string contains the second string at any location
'Print the location of the match for part 2
second$ = "wert"
x = INSTR(first$, second$)
IF x THEN
    PRINT "'"; first$; "' contains '"; second$; "' at position "; x
ELSE
    PRINT "'"; first$; "' does not contain '"; second$; "'"
END IF

' Determining if the first string ends with the second string
second$ = "random garbage"
IF RIGHT$(first$, LEN(second$)) = second$ THEN
    PRINT "'"; first$; "' ends with '"; second$; "'"
ELSE
    PRINT "'"; first$; "' does not end with '"; second$; "'"
END IF
