      MODULE PQ	!Plays with some integer arithmetic.
       INTEGER MSG	!Output unit number.
       CONTAINS		!One good routine.
        INTEGER FUNCTION GCD(I,J)	!Greatest common divisor.
         INTEGER I,J	!Of these two integers.
         INTEGER N,M,R	!Workers.
          N = MAX(I,J)	!Since I don't want to damage I or J,
          M = MIN(I,J)	!These copies might as well be the right way around.
    1     R = MOD(N,M)		!Divide N by M to get the remainder R.
          IF (R.GT.0) THEN	!Remainder zero?
            N = M			!No. Descend a level.
            M = R			!M-multiplicity has been removed from N.
            IF (R .GT. 1) GO TO 1	!No point dividing by one.
          END IF			!If R = 0, M divides N.
          GCD = M			!There we are.
        END FUNCTION GCD	!Euclid lives on!

        SUBROUTINE RATIONAL10(X)!By contrast, this is rather crude.
         DOUBLE PRECISION X	!The number.
         DOUBLE PRECISION R	!Its latest rational approach.
         INTEGER P,Q		!For R = P/Q.
         INTEGER F,WHACK	!Assistants.
         PARAMETER (WHACK = 10**8)	!The rescale...
          P = X*WHACK + 0.5	!Multiply by WHACK/WHACK = 1 and round to integer.
          Q = WHACK		!Thus compute X/1, sortof.
          F = GCD(P,Q)		!Perhaps there is a common factor.
          P = P/F		!Divide it out.
          Q = Q/F		!For a proper rational number.
          R = DBLE(P)/DBLE(Q)	!So, where did we end up?
          WRITE (MSG,1) P,Q,X - R,WHACK	!Details.
    1     FORMAT ("x - ",I0,"/",I0,T28," = ",F18.14,
     1     " via multiplication by ",I0)
        END SUBROUTINE RATIONAL10	!Enough of this.

        SUBROUTINE RATIONAL(X)	!Use brute force in a different way.
         DOUBLE PRECISION X	!The number.
         DOUBLE PRECISION R,E,BEST	!Assistants.
         INTEGER P,Q		!For R = P/Q.
         INTEGER TRY,F		!Floundering.
          P = 1 + X	!Prevent P = 0.
          Q = 1		!So, X/1, sortof.
          BEST = X*6	!A largeish value for the first try.
          DO TRY = 1,10000000	!Pound away.
            R = DBLE(P)/DBLE(Q)		!The current approximation.
            E = X - R			!Deviation.
            IF (ABS(E) .LE. BEST) THEN	!Significantly better than before?
              BEST = ABS(E)*0.125		!Yes. Demand eightfold improvement to notice.
              F = GCD(P,Q)			!We may land on a multiple.
              IF (BEST.LT.0.1D0) WRITE (MSG,1) P/F,Q/F,E	!Skip early floundering.
    1         FORMAT ("x - ",I0,"/",I0,T28," = ",F18.14)	!Try to align columns.
              IF (F.NE.1) WRITE (MSG,*) "Common factor!",F	!A surprise!
              IF (E.EQ.0) EXIT			!Perhaps we landed a direct hit?
            END IF			!So much for possible announcements.
            IF (E.GT.0) THEN	!Is R too small?
              P = P + CEILING(E*Q)	!Yes. Make P bigger by the shortfall.
            ELSE IF (E .LT. 0) THEN	!But perhaps R is too big?
              Q = Q + 1			!If so, use a smaller interval.
            END IF		!So much for adjustments.
          END DO		!Try again.
        END SUBROUTINE RATIONAL	!Limited integers, limited sense.

        SUBROUTINE RATIONALISE(X,WOT)	!Run the tests.
         DOUBLE PRECISION X	!The value.
         CHARACTER*(*) WOT	!Some blather.
          WRITE (MSG,*) X,WOT	!Explanations can help.
          CALL RATIONAL10(X)	!Try a crude method.
          CALL RATIONAL(X)	!Try a laborious method.
          WRITE (MSG,*)		!Space off.
        END SUBROUTINE RATIONALISE	!That wasn't much fun.
      END MODULE PQ	!But computer time is cheap.

      PROGRAM APPROX
      USE PQ
      DOUBLE PRECISION PI,E
      MSG = 6
      WRITE (MSG,*) "Rational numbers near to decimal values."
      WRITE (MSG,*)
      PI = 1		!Thus get a double precision conatant.
      PI = 4*ATAN(PI)	!That will determine the precision of ATAN.
      E = DEXP(1.0D0)	!Rather than blabber on about 1 in double precision.
      CALL RATIONALISE(0.1D0,"1/10 Repeating in binary..")
      CALL RATIONALISE(3.14159D0,"Pi approx.")
      CALL RATIONALISE(PI,"Pi approximated better.")
      CALL RATIONALISE(E,"e: rational approximations aren't much use.")
      CALL RATIONALISE(10.15D0,"Exact in decimal, recurring in binary.")
      WRITE (MSG,*)
      WRITE (MSG,*) "Variations on 67/74"
      CALL RATIONALISE(0.9054D0,"67/74 = 0·9(054) repeating in base 10")
      CALL RATIONALISE(0.9054054D0,"Two repeats.")
      CALL RATIONALISE(0.9054054054D0,"Three repeats.")
      WRITE (MSG,*)
      WRITE (MSG,*) "Variations on 14/27"
      CALL RATIONALISE(0.518D0,"14/27 = 0·(518) repeating in decimal.")
      CALL RATIONALISE(0.519D0,"Rounded.")
      CALL RATIONALISE(0.518518D0,"Two repeats, truncated.")
      CALL RATIONALISE(0.518519D0,"Two repeats, rounded.")
      END
