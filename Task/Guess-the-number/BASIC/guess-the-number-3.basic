supervisor:
GOSUB initialize
GOSUB guessing
GOTO continue

initialize:
RANDOMIZE TIMER
n = 0: r = INT(RND * 100 + 1): g = 0: c$ = ""
RETURN

guessing:
WHILE g <> r
    INPUT "Pick a number between 1 and 100"; g
    IF g = r THEN
        PRINT "You got it!"
        n = n + 1
        PRINT "It took "; n; "tries to pick the right number."
    ELSEIF g < r THEN
        PRINT "Try a larger number."
        n = n + 1
    ELSE
        PRINT "Try a smaller number."
        n = n + 1
    END IF
WEND
RETURN

continue:
WHILE c$ <> "YES" AND c$ <> "NO"
    INPUT "Do you want to continue? (YES/NO)"; c$
    c$ = UCASE$(c$)
    IF c$ = "YES" THEN
        GOTO supervisor
    ELSEIF c$ = "NO" THEN
        STOP
    END IF
WEND
