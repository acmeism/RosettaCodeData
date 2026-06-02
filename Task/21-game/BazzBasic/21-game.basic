' ============================================
' 21 GAME - BazzBasic Edition
' https://rosettacode.org/wiki/21_game
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' Two players alternate saying 1, 2, or 3.
' That number is added to a running total.
' The player who reaches exactly 21 WINS!
' ============================================

[inits]
    LET BLACK#   = 0
    LET CYAN#    = 3
    LET MAGENTA# = 5
    LET LGRAY#   = 7
    LET DGRAY#   = 8
    LET LGREEN#  = 10
    LET LRED#    = 12
    LET YELLOW#  = 14
    LET WHITE#   = 15

[title]
    CLS
    COLOR YELLOW#, BLACK#
    PRINT "\n "; REPEAT("*", 40)
    PRINT " *"; REPEAT(" ", 38); "*"
    PRINT " *          ";
    COLOR WHITE#, BLACK#
    PRINT "T H E   2 1   G A M E";
    COLOR YELLOW#, BLACK#
    PRINT "          *"
    PRINT " *"; REPEAT(" ", 38); "*"
    PRINT " "; REPEAT("*", 40)
    COLOR LGRAY#, BLACK#
    PRINT "\n Rosetta Code task: rosettacode.org/wiki/21_game"
    PRINT " BazzBasic Edition\n"
    COLOR CYAN#, BLACK#
    PRINT " RULES:"
    COLOR WHITE#, BLACK#
    PRINT " - Running total starts at 0"
    PRINT " - Take turns saying a number: 1, 2, or 3"
    PRINT " - That number is added to the running total"
    PRINT " - The player who reaches exactly 21 WINS!\n"
    COLOR YELLOW#, BLACK#
    PRINT " Hint: there IS a perfect strategy...\n"
    COLOR WHITE#, BLACK#
    PRINT REPEAT("-", 50)
    PRINT " Press ENTER to start...";
    WAITKEY(KEY_ENTER#)

[main]
    LET total$ = 0
    LET winner$ = ""

    ' Randomly decide who goes first
    IF RND(2) = 0 THEN
        LET first$  = "[sub:playerTurn]"
        LET second$ = "[sub:computerTurn]"
    ELSE
        LET first$  = "[sub:computerTurn]"
        LET second$ = "[sub:playerTurn]"
    END IF

    [roundLoop]
        CLS
        GOSUB [sub:drawTotal]

        GOSUB first$
        IF total$ = 21 THEN winner$ = first$ : GOTO [roundDone]

        GOSUB second$
        IF total$ = 21 THEN winner$ = second$ : GOTO [roundDone]

        GOTO [roundLoop]

[roundDone]
    CLS
    GOSUB [sub:drawTotal]

    IF winner$ = "[sub:playerTurn]" THEN
        COLOR LGREEN#, BLACK#
        PRINT "\n "; REPEAT("*", 34)
        PRINT " *  YOU WIN! You reached 21!  *"
        PRINT " "; REPEAT("*", 34)
        COLOR WHITE#, BLACK#
        PRINT "\n You found the strategy!"
    ELSE
        COLOR LRED#, BLACK#
        PRINT "\n "; REPEAT("*", 32)
        PRINT " *  I WIN! I reached 21.  *"
        PRINT " "; REPEAT("*", 32)
        COLOR YELLOW#, BLACK#
        PRINT "\n Better luck next time!"
    END IF

    COLOR WHITE#, BLACK#
    PRINT "\n Play again? ENTER = yes, ESC = quit"
    LET k$ = WAITKEY(KEY_ENTER#, KEY_ESC#)
    IF k$ = KEY_ESC# THEN END
    GOTO [main]

' ============================================
' SHOW THE RUNNING TOTAL WITH A PROGRESS BAR
' ============================================
[sub:drawTotal]
    COLOR YELLOW#, BLACK#
    PRINT "\n "; REPEAT("=", 44)
    PRINT "          RUNNING TOTAL:  ";
    COLOR WHITE#, BLACK#
    PRINT total$; " / 21"
    COLOR YELLOW#, BLACK#
    PRINT " "; REPEAT("=", 44); "\n"
    COLOR CYAN#, BLACK#
    PRINT "  [";
    COLOR LGREEN#, BLACK#
    PRINT REPEAT("|", total$);
    COLOR DGRAY#, BLACK#
    PRINT REPEAT(".", 21 - total$);
    COLOR CYAN#, BLACK#
    PRINT "] ";
    COLOR WHITE#, BLACK#
    PRINT total$; "\n"
RETURN

' ============================================
' PLAYER'S TURN
' ============================================
[sub:playerTurn]
    COLOR LGREEN#, BLACK#
    PRINT " YOUR TURN — press 1, 2 or 3: ";
    COLOR WHITE#, BLACK#

    LET key$ = WAITKEY(KEY_1#, KEY_2#, KEY_3#)
    LET said$ = key$ - 48

    WHILE total$ + said$ > 21
        COLOR LRED#, BLACK#
        PRINT said$; "  (would exceed 21!)"
        PRINT " Choose 1 to "; 21 - total$; ": ";
        COLOR WHITE#, BLACK#
        LET key$ = WAITKEY(KEY_1#, KEY_2#, KEY_3#)
        LET said$ = key$ - 48
    WEND

    total$ = total$ + said$
    COLOR CYAN#, BLACK#
    PRINT said$; "  — total is now "; total$; "\n"
    SLEEP 700
RETURN

' ============================================
' COMPUTER'S TURN - optimal strategy
' ============================================
' Losing positions: 1, 5, 9, 13, 17 (all 1 mod 4)
' Formula: say = (4 + 1 - total mod 4) mod 4
' If result is 0 we are in a losing position -> random
' ============================================
[sub:computerTurn]
    COLOR LRED#, BLACK#
    PRINT " COMPUTER'S TURN"
    COLOR WHITE#, BLACK#
    SLEEP 900

    IF 21 - total$ >= 1 AND 21 - total$ <= 3 THEN
        LET compSaid$ = 21 - total$
        GOTO [doCompMove]
    END IF

    LET compSaid$ = MOD(4 + 1 - MOD(total$, 4), 4)
    IF compSaid$ = 0 THEN LET compSaid$ = INT(RND(3)) + 1
    IF total$ + compSaid$ > 21 THEN LET compSaid$ = 21 - total$

    [doCompMove]
    total$ = total$ + compSaid$
    COLOR MAGENTA#, BLACK#
    PRINT " I say "; compSaid$; " — total is now "; total$; "\n"
    SLEEP 1200
RETURN
