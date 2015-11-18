      SUBROUTINE ULAMSPIRAL(START,ORDER)	!Idle scribbles can lead to new ideas.
Careful with phasing: each lunge's first number is the second placed along its direction.
       INTEGER START	!Usually 1.
       INTEGER ORDER	!MUST be an odd number, so there is a middle.
       INTEGER L,M,N	!Counters.
       COMPLEX WAY,PLACE	!Just so.
       CHARACTER*1 SPLOT(0:1)	!Tricks for output.
       PARAMETER (SPLOT = (/" ","*"/))	!Selected according to ISPRIME(n)
       INTEGER TILE(ORDER,ORDER)	!Work area.
        WRITE (6,1) START,ORDER	!Here we go.
    1   FORMAT ("Ulam spiral starting with ",I0,", of order ",I0,/)
        IF (MOD(ORDER,2) .NE. 1) STOP "The order must be odd!"	!Otherwise, out of bounds.
        M = ORDER/2 + 1		!Find the number of the middle.
        PLACE = CMPLX(M,M)	!Start there.
        WAY = (1,0)		!Thence in the +x direction.
        N = START		!Different start, different layout.
        DO L = 1,ORDER		!Advance one step, then two, then three, etc.
          DO LUNGE = 1,2		!But two lunges for each length.
            DO STEP = 1,L			!Take the steps.
              TILE(INT(REAL(PLACE)),INT(AIMAG(PLACE))) = N	!This number for this square.
              PLACE = PLACE + WAY		!Make another step.
              N = N + 1				!Count another step.
            END DO				!And consider making another.
            IF (N .GE. ORDER**2) EXIT	!Otherwise, one lunge too many!
            WAY = WAY*(0,1)		!Rotate a quarter-turn counter-clockwise.
          END DO			!And make another lunge.
        END DO			!Until finished.
Cast forth the numbers.
c        DO L = ORDER,1,-1	!From the top of the grid to the bottom.
c          WRITE (6,66) TILE(1:ORDER,L)	!One row at at time.
c   66     FORMAT (666I6)	!This will do for reassurance.
c        END DO			!Line by line.
Cast forth the splots.
        DO L = ORDER,1,-1	!Just put out a marker.
          WRITE (6,67) (SPLOT(ISPRIME(TILE(M,L))),M = 1,ORDER)	!One line at a time.
   67     FORMAT (666A1)	!A single character at each position.
        END DO			!On to the next row.
      END SUBROUTINE ULAMSPIRAL	!So much for a boring lecture.

      INTEGER FUNCTION ISPRIME(N)	!Returns 0 or 1.
       INTEGER N	!The number.
       INTEGER F,Q	!Factor and quotient.
        ISPRIME = 0		!The more likely outcome.
        IF (N.LE.1) RETURN	!Just in case the start is peculiar.
        IF (N.LE.3) GO TO 2	!Oops! I forgot this!
        IF (MOD(N,2).EQ.0) RETURN	!Special case.
        F = 1			!Now get stuck in to testing odd numbers.
    1   F = F + 2		!A trial factor.
        Q = N/F			!The quotient.
        IF (N .EQ. Q*F) RETURN	!No remainder? Not a prime.
        IF (Q.GT.F) GO TO 1	!Thus chug up to the square root.
    2   ISPRIME = 1		!Well!
      END FUNCTION ISPRIME	!Simple enough.

      PROGRAM TWIRL
        CALL ULAMSPIRAL(1,49)
      END
