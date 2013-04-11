DEFINT A-Z

DIM secret AS STRING
DIM guess  AS STRING
DIM c      AS STRING
DIM bulls, cows, guesses, i

RANDOMIZE TIMER
DO WHILE LEN(secret) < 4
    c = CHR$(INT(RND * 10) + 48)
    IF INSTR(secret, c) = 0 THEN secret = secret + c
LOOP

guesses = 0
DO
    INPUT "Guess a 4-digit number with no duplicate digits: "; guess
    guess = LTRIM$(RTRIM$(guess))
    IF LEN(guess) = 0 THEN EXIT DO

    IF LEN(guess) <> 4 OR VAL(guess) = 0 THEN
        PRINT "** You should enter 4 numeric digits!"
        GOTO looper
    END IF

    bulls = 0: cows = 0: guesses = guesses + 1
    FOR i = 1 TO 4
        c = MID$(secret, i, 1)
        IF MID$(guess, i, 1) = c THEN
            bulls = bulls + 1
        ELSEIF INSTR(guess, c) THEN
            cows = cows + 1
        END IF
    NEXT i
    PRINT bulls; " bulls, "; cows; " cows"

    IF guess = secret THEN
        PRINT "You won after "; guesses; " guesses!"
        EXIT DO
    END IF
looper:
LOOP
