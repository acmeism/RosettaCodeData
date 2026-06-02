' ============================================
' 24 GAME - BazzBasic Edition
' https://rosettacode.org/wiki/24_game
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' Use  +  -  *  /  with four given digits to make 24.
' Enter your expression in Reverse Polish Notation (RPN).
' ============================================

[inits]
	' Color constants
	LET BLACK#   = 0
	LET CYAN#    = 3
	LET MAGENTA# = 5
	LET LGRAY#   = 7
	LET LGREEN#  = 10
	LET LRED#    = 12
	LET YELLOW#  = 14
	LET WHITE#   = 15

	' Shared arrays — declared once at top level
	DIM digits$     ' the 4 given digits, indices 0-3
	DIM rpnStack$   ' RPN evaluation stack
	DIM usedDigits$ ' digits extracted from player expression
	DIM tokens$     ' tokenized input
	DIM givenCnt$   ' digit frequency: what was given
	DIM usedCnt$    ' digit frequency: what was typed

	' Solver working variables
	LET solvable$    = FALSE
	LET sp3$         = 0
	LET sa$          = 0
	LET sb$          = 0
	LET sc$          = 0
	LET sd$          = 0
	LET st1$         = 0

	' Operator application (shared by solver and evaluator)
	LET opA$         = 0
	LET opB$         = 0
	LET opIdx$       = 0
	LET opOk$        = FALSE
	LET opResult$    = 0

	' Player round variables
	LET keepPlaying$ = FALSE
	LET expr$        = ""
	LET choice$      = ""

	' RPN evaluator output
	LET sp$          = 0
	LET digitCount$  = 0
	LET evalValid$   = FALSE
	LET evalResult$  = 0
	LET evalDigitsOk$ = FALSE
	LET evalError$   = ""
	LET tokenCount$  = 0
	LET tok$         = ""
	LET d$           = 0

GOSUB [sub:title]

[sub:newGame]
	GOSUB [sub:generateDigits]
	GOSUB [sub:checkSolvable]
	GOSUB [sub:playRound]
	GOTO [sub:newGame]
END

' ============================================
' TITLE SCREEN
' ============================================
[sub:title]
	CLS
	COLOR YELLOW#, BLACK#
	PRINT "\n "; REPEAT("*", 44)
	PRINT " *"; REPEAT(" ", 42); "*"
	PRINT " *           ";
	COLOR WHITE#, BLACK#
	PRINT "T H E   2 4   G A M E";
	COLOR YELLOW#, BLACK#
	PRINT "           *"
	PRINT " *"; REPEAT(" ", 42); "*"
	PRINT " "; REPEAT("*", 44)

	COLOR LGRAY#, BLACK#
	PRINT "\n Rosetta Code task: rosettacode.org/wiki/24_game"
	PRINT " BazzBasic Edition\n"

	COLOR CYAN#, BLACK#
	PRINT " RULES:"
	COLOR WHITE#, BLACK#
	PRINT " - You are given four digits (1-9, repeats possible)"
	PRINT " - Use  +  -  *  /  with all four digits to make 24"
	PRINT " - Each digit must be used exactly once"
	PRINT " - Multi-digit numbers are not allowed\n"

	COLOR CYAN#, BLACK#
	PRINT " INPUT: Reverse Polish Notation (RPN)"
	COLOR WHITE#, BLACK#
	PRINT " - Write operands first, then the operator"
	PRINT " - Separate every token with spaces\n"
	COLOR LGRAY#, BLACK#
	PRINT "   Infix               RPN                 Result"
	PRINT "   (2 + 4) * 3         2 4 + 3 *           18"
	PRINT "   8 * (3 - 2)         8 3 2 - *           8"
	PRINT "   3*4 + 6/2           3 4 * 6 2 / +       15"
	PRINT "   (1+2+3) * 4         1 2 + 3 + 4 *       24  <-- makes 24!\n"

	COLOR WHITE#, BLACK#
	PRINT REPEAT("-", 50)
	PRINT " Press ENTER to start...";
	WAITKEY(KEY_ENTER#)
	PRINT ""
RETURN

' ============================================
' GENERATE 4 RANDOM DIGITS (1-9)
' ============================================
[sub:generateDigits]
	FOR i$ = 0 TO 3
		digits$(i$) = INT(RND(9)) + 1
	NEXT
RETURN

' ============================================
' BRUTE-FORCE SOLVER
' Tries all 4! * 4^3 * 5 = 7680 combinations.
' Sets solvable$ = TRUE if any combination reaches 24.
'
' The 5 distinct parenthesizations for 4 values:
'   Form 1: ((a op b) op c) op d
'   Form 2: (a op (b op c)) op d
'   Form 3: (a op b) op (c op d)
'   Form 4: a op ((b op c) op d)
'   Form 5: a op (b op (c op d))
' ============================================
[sub:checkSolvable]
	solvable$ = FALSE

	FOR sp0$ = 0 TO 3
		FOR sp1$ = 0 TO 3
			IF sp1$ <> sp0$ THEN
				FOR sp2$ = 0 TO 3
					IF sp2$ <> sp0$ AND sp2$ <> sp1$ THEN
						sp3$ = 6 - sp0$ - sp1$ - sp2$

						sa$ = digits$(sp0$)
						sb$ = digits$(sp1$)
						sc$ = digits$(sp2$)
						sd$ = digits$(sp3$)

						FOR so1$ = 0 TO 3
							FOR so2$ = 0 TO 3
								FOR so3$ = 0 TO 3
									IF solvable$ = FALSE THEN
										GOSUB [sub:tryForms]
									END IF
								NEXT
							NEXT
						NEXT

					END IF
				NEXT
			END IF
		NEXT
	NEXT
RETURN

' ============================================
' TRY ALL 5 PARENTHESIZATION FORMS
' Uses: sa$, sb$, sc$, sd$, so1$, so2$, so3$
' Sets: solvable$
' ============================================
[sub:tryForms]
	' --- Form 1: ((a op1 b) op2 c) op3 d ---
	opA$ = sa$ : opB$ = sb$ : opIdx$ = so1$ : GOSUB [sub:applyOp]
	IF opOk$ THEN
		opA$ = opResult$ : opB$ = sc$ : opIdx$ = so2$ : GOSUB [sub:applyOp]
		IF opOk$ THEN
			opA$ = opResult$ : opB$ = sd$ : opIdx$ = so3$ : GOSUB [sub:applyOp]
			IF opOk$ AND ABS(opResult$ - 24) < 0.0001 THEN solvable$ = TRUE
		END IF
	END IF

	' --- Form 2: (a op2 (b op1 c)) op3 d ---
	opA$ = sb$ : opB$ = sc$ : opIdx$ = so1$ : GOSUB [sub:applyOp]
	IF opOk$ THEN
		opA$ = sa$ : opB$ = opResult$ : opIdx$ = so2$ : GOSUB [sub:applyOp]
		IF opOk$ THEN
			opA$ = opResult$ : opB$ = sd$ : opIdx$ = so3$ : GOSUB [sub:applyOp]
			IF opOk$ AND ABS(opResult$ - 24) < 0.0001 THEN solvable$ = TRUE
		END IF
	END IF

	' --- Form 3: (a op1 b) op3 (c op2 d) ---
	opA$ = sa$ : opB$ = sb$ : opIdx$ = so1$ : GOSUB [sub:applyOp]
	IF opOk$ THEN
		st1$ = opResult$
		opA$ = sc$ : opB$ = sd$ : opIdx$ = so2$ : GOSUB [sub:applyOp]
		IF opOk$ THEN
			opA$ = st1$ : opB$ = opResult$ : opIdx$ = so3$ : GOSUB [sub:applyOp]
			IF opOk$ AND ABS(opResult$ - 24) < 0.0001 THEN solvable$ = TRUE
		END IF
	END IF

	' --- Form 4: a op3 ((b op1 c) op2 d) ---
	opA$ = sb$ : opB$ = sc$ : opIdx$ = so1$ : GOSUB [sub:applyOp]
	IF opOk$ THEN
		opA$ = opResult$ : opB$ = sd$ : opIdx$ = so2$ : GOSUB [sub:applyOp]
		IF opOk$ THEN
			opA$ = sa$ : opB$ = opResult$ : opIdx$ = so3$ : GOSUB [sub:applyOp]
			IF opOk$ AND ABS(opResult$ - 24) < 0.0001 THEN solvable$ = TRUE
		END IF
	END IF

	' --- Form 5: a op3 (b op2 (c op1 d)) ---
	opA$ = sc$ : opB$ = sd$ : opIdx$ = so1$ : GOSUB [sub:applyOp]
	IF opOk$ THEN
		opA$ = sb$ : opB$ = opResult$ : opIdx$ = so2$ : GOSUB [sub:applyOp]
		IF opOk$ THEN
			opA$ = sa$ : opB$ = opResult$ : opIdx$ = so3$ : GOSUB [sub:applyOp]
			IF opOk$ AND ABS(opResult$ - 24) < 0.0001 THEN solvable$ = TRUE
		END IF
	END IF
RETURN

' ============================================
' APPLY ONE OPERATOR
' In:  opA$, opB$, opIdx$ (0=+ 1=- 2=* 3=/)
' Out: opResult$, opOk$
' ============================================
[sub:applyOp]
	opOk$ = TRUE
	IF opIdx$ = 0 THEN opResult$ = opA$ + opB$
	IF opIdx$ = 1 THEN opResult$ = opA$ - opB$
	IF opIdx$ = 2 THEN opResult$ = opA$ * opB$
	IF opIdx$ = 3 THEN
		IF opB$ = 0 THEN
			opOk$ = FALSE
		ELSE
			opResult$ = opA$ / opB$
		END IF
	END IF
RETURN

' ============================================
' DISPLAY THE FOUR DIGITS
' ============================================
[sub:showDigits]
	COLOR YELLOW#, BLACK#
	PRINT "\n "; REPEAT("=", 44)
	PRINT "          YOUR FOUR DIGITS:"
	COLOR WHITE#, BLACK#
	PRINT "\n          ";
	FOR i$ = 0 TO 3
		COLOR YELLOW#, BLACK#
		PRINT "[ ";
		COLOR WHITE#, BLACK#
		PRINT digits$(i$);
		COLOR YELLOW#, BLACK#
		PRINT " ]  ";
	NEXT
	PRINT ""

	IF solvable$ = FALSE THEN
		COLOR LRED#, BLACK#
		PRINT "\n          (no solution exists for these digits)"
	END IF

	COLOR YELLOW#, BLACK#
	PRINT "\n "; REPEAT("=", 44); "\n"
	COLOR WHITE#, BLACK#
RETURN

' ============================================
' PLAY ROUND  (same 4 digits until player moves on)
' ============================================
[sub:playRound]
	keepPlaying$ = TRUE

	WHILE keepPlaying$
		CLS
		GOSUB [sub:showDigits]

		COLOR LGREEN#, BLACK#
		PRINT " RPN expression: ";
		COLOR WHITE#, BLACK#
		LINE INPUT "", expr$
		expr$ = TRIM(expr$)
		PRINT ""

		GOSUB [sub:evaluate]

		IF evalValid$ = FALSE THEN
			COLOR LRED#, BLACK#
			PRINT " ! "; evalError$

		ELSEIF evalDigitsOk$ = FALSE THEN
			COLOR LRED#, BLACK#
			PRINT " ! Wrong digits. You must use exactly: ";
			COLOR WHITE#, BLACK#
			FOR i$ = 0 TO 3
				PRINT digits$(i$); " ";
			NEXT
			PRINT ""

		ELSEIF ABS(evalResult$ - 24) < 0.0001 THEN
			COLOR LGREEN#, BLACK#
			PRINT " Result = 24"
			PRINT "\n *** Correct! You made 24! ***\n"
			COLOR WHITE#, BLACK#
			PRINT " Press ENTER for new digits...";
			WAITKEY(KEY_ENTER#)
			PRINT ""
			keepPlaying$ = FALSE

		ELSE
			COLOR LGRAY#, BLACK#
			PRINT " Result = "; evalResult$; "  — not 24."
		END IF

		IF keepPlaying$ THEN
			COLOR WHITE#, BLACK#
			PRINT "\n [ENTER] try again    [N] new digits    [Q] quit"
			PRINT " > ";
			LINE INPUT "", choice$
			choice$ = UCASE(TRIM(choice$))
			IF choice$ = "Q" THEN END
			IF choice$ = "N" THEN
				GOSUB [sub:generateDigits]
				GOSUB [sub:checkSolvable]
			END IF
		END IF
	WEND
RETURN

' ============================================
' RPN EVALUATOR
' Reads:  expr$, digits$()
' Writes: evalResult$, evalValid$, evalDigitsOk$, evalError$
' ============================================
[sub:evaluate]
	sp$           = 0
	digitCount$   = 0
	evalValid$    = TRUE
	evalResult$   = 0
	evalDigitsOk$ = FALSE
	evalError$    = ""

	tokenCount$ = SPLIT(tokens$, expr$, " ")

	FOR ti$ = 0 TO tokenCount$ - 1
		IF evalValid$ = FALSE THEN GOTO [evalDone]

		tok$ = tokens$(ti$)

		IF LEN(tok$) > 0 THEN

			IF tok$ = "+" OR tok$ = "-" OR tok$ = "*" OR tok$ = "/" THEN
				IF sp$ < 2 THEN
					evalValid$ = FALSE
					evalError$ = "Operator '" + tok$ + "' needs two values on the stack."
					evalError$ += "\n   Looks like infix? RPN example:  1 8 * 1 1 * +"
				ELSE
					opB$ = rpnStack$(sp$ - 1)
					opA$ = rpnStack$(sp$ - 2)
					sp$ -= 2
					opIdx$ = 0
					IF tok$ = "-" THEN opIdx$ = 1
					IF tok$ = "*" THEN opIdx$ = 2
					IF tok$ = "/" THEN opIdx$ = 3
					GOSUB [sub:applyOp]
					IF opOk$ = FALSE THEN
						evalValid$ = FALSE
						evalError$ = "Division by zero."
					ELSE
						rpnStack$(sp$) = opResult$
						sp$ += 1
					END IF
				END IF

			ELSEIF LEN(tok$) = 1 AND VAL(tok$) >= 1 AND VAL(tok$) <= 9 THEN
				usedDigits$(digitCount$) = VAL(tok$)
				digitCount$ += 1
				rpnStack$(sp$) = VAL(tok$)
				sp$ += 1

			ELSE
				evalValid$ = FALSE
				evalError$ = "Invalid token: \"" + tok$ + "\""
				evalError$ += "  (use digits 1-9 and operators + - * / only)"
			END IF

		END IF
	NEXT

	IF evalValid$ AND sp$ = 1 THEN
		evalResult$ = rpnStack$(0)
	ELSE
		evalValid$ = FALSE
		IF evalError$ = "" THEN evalError$ = "Incomplete expression — too few operators?"
	END IF

	[evalDone]

	IF evalValid$ AND digitCount$ = 4 THEN
		FOR i$ = 1 TO 9
			givenCnt$(i$) = 0
			usedCnt$(i$) = 0
		NEXT
		FOR i$ = 0 TO 3
			d$ = digits$(i$)
			givenCnt$(d$) += 1
		NEXT
		FOR i$ = 0 TO 3
			d$ = usedDigits$(i$)
			usedCnt$(d$) += 1
		NEXT
		evalDigitsOk$ = TRUE
		FOR i$ = 1 TO 9
			IF givenCnt$(i$) <> usedCnt$(i$) THEN evalDigitsOk$ = FALSE
		NEXT
	END IF
RETURN
