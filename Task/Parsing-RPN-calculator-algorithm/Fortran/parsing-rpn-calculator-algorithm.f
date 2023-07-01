      REAL FUNCTION EVALRP(TEXT)	!Evaluates a Reverse Polish string.
Caution: deals with single digits only.
       CHARACTER*(*) TEXT	!The RPN string.
       INTEGER SP,STACKLIMIT		!Needed for the evaluation.
       PARAMETER (STACKLIMIT = 6)	!This should do.
       REAL*8 STACK(STACKLIMIT)		!Though with ^ there's no upper limit.
       INTEGER L,D		!Assistants for the scan.
       CHARACTER*4 DEED		!A scratchpad for the annotation.
       CHARACTER*1 C		!The character of the moment.
        WRITE (6,1) TEXT	!A function that writes messages... Improper.
    1   FORMAT ("Evaluation of the Reverse Polish string ",A,//	!Still, it's good to see stuff.
     1   "Char Token Action  SP:Stack...")	!Such as a heading for the trace.
        SP = 0			!Commence with the stack empty.
        STACK = -666		!This value should cause trouble.
        DO L = 1,LEN(TEXT)	!Step through the text.
          C = TEXT(L:L)			!Grab a character.
          IF (C.LE." ") CYCLE		!Boring.
          D = ICHAR(C) - ICHAR("0")	!Uncouth test to check for a digit.
          IF (D.GE.0 .AND. D.LE.9) THEN	!Is it one?
            DEED = "Load"			!Yes. So, load its value.
            SP = SP + 1				!By going up one.
            IF (SP.GT.STACKLIMIT) STOP "Stack overflow!"	!Or, maybe not.
            STACK(SP) = D			!And stashing the value.
           ELSE				!Otherwise, it must be an operator.
            IF (SP.LT.2) STOP "Stack underflow!"	!They all require two operands.
            DEED = "XEQ"		!So, I'm about to do so.
            SELECT CASE(C)		!Which one this time?
             CASE("+"); STACK(SP - 1) = STACK(SP - 1) + STACK(SP)	!A + B = B + A, so it is easy.
             CASE("-"); STACK(SP - 1) = STACK(SP - 1) - STACK(SP)	!A is in STACK(SP - 1), B in STACK(SP)
             CASE("*"); STACK(SP - 1) = STACK(SP - 1)*STACK(SP)		!Again, order doesn't count.
             CASE("/"); STACK(SP - 1) = STACK(SP - 1)/STACK(SP)		!But for division, A/B becomes A B /
             CASE("^"); STACK(SP - 1) = STACK(SP - 1)**STACK(SP)	!So, this way around.
             CASE DEFAULT		!This should never happen!
              STOP "Unknown operator!"	!If the RPN script is indeed correct.
            END SELECT			!So much for that operator.
            SP = SP - 1		!All of them take two operands and make one.
          END IF		!So much for that item.
          WRITE (6,2) L,C,DEED,SP,STACK(1:SP)	!Reveal the state now.
    2     FORMAT (I4,A6,A7,I4,":",66F14.6)	!Aligned with the heading of FORMAT 1.
        END DO			!On to the next symbol.
        EVALRP = STACK(1)	!The RPN string being correct, this is the result.
      END	!Simple enough!

      PROGRAM HSILOP
      REAL V
      V = EVALRP("3 4 2 * 1 5 - 2 3 ^ ^ / +")	!The specified example.
      WRITE (6,*) "Result is...",V
      END
