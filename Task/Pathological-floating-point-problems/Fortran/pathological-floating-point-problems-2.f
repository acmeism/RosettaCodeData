      SUBROUTINE CBS	!The Chaotic Bank Society.
       INTEGER YEAR	!A stepper.
       REAL*4 V		!The balance.
       REAL*8 W		!In double precision as well.
       INTEGER NTERM	!Share information with CBSERIES.
       REAL*8 T		!So as to show workings.
        V = 1; W = 1		!Initial values, without dozy 1D0 stuff.
        V = EXP(V) - 1		!Actual initial value desired is e - 1..,
        W = EXP(W) - 1		!This relies on double-precision W selecting DEXP.
        WRITE (6,1)		!Here we go.
    1   FORMAT (///"The Chaotic Bank Society in action...",/,
     *   "Year",9X,"Real*4",22X,"Real*8",12X,"Series summation",
     *   9X,"Last term",2X,"Terms.")
        WRITE (6,2) 0,V,W,CBSERIES(0),T,NTERM	!Show the initial deposit.
    2   FORMAT (I3,F16.7,2F28.16,D18.8,I7)	!Not quite 16-digit precision for REAL*8.
        DO YEAR = 1,25		!Step through some years.
          V = V*YEAR - 1	!The specified procedure.
          W = W*YEAR - 1	!The compiler handles type conversions.
          WRITE (6,2) YEAR,V,W,CBSERIES(YEAR),T,NTERM	!The current balance.
        END DO			!On to the following year.
        CONTAINS		!An alternative.
        REAL*8 FUNCTION CBSERIES(N)	!Calculates for the special deposit of e - 1.
         INTEGER N	!Desire the balance after year N for the deposit of e - 1.
         REAL*8 S	!Via a series summation.
          S = 0			!Start the summation.
          T = 1			!First term is 1/(N + 1)
          I = N			!Second is 1/[(N + 1)*(N + 2)], etc.
          NTERM = 0		!No terms so far.
    3       NTERM = NTERM + 1	!Here we go.
            I = I + 1		!Thus advance to the next divisor, and not divide by zero.
            T = T/I		!Thus not compute the products from scratch each time.
            S = S + T		!Add the term.
            IF (T/S .GE. EPSILON(S)) GO TO 3	!If they're still making a difference, another.
          CBSERIES = S		!Convergence is ever-faster as N increases.
        END FUNCTION CBSERIES	!So this is easy.
      END SUBROUTINE CBS	!Madness!
