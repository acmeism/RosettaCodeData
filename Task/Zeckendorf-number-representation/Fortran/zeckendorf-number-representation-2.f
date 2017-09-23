      MODULE ZECKENDORF ARITHMETIC	!Using the Fibonacci series, rather than powers of some base.
       INTEGER ZLAST		!The standard 32-bit two's complement integers
       PARAMETER (ZLAST = 45)	!only get so far, just as there's a limit to the highest power.
       INTEGER F1B(ZLAST)	!I want the Fibonacci series, and, starting with its second one.
c       PARAMETER (F1B = (/1,2,	!But alas, the compiler doesn't allow
c     3  F1B(1) + F1B(2),		!for this sort of carpet-unrolling
c     4  F1B(2) + F1B(3), 		!initialisation sequence.
       INTEGER,PRIVATE:: F01,F02,F03,F04,F05,F06,F07,F08,F09,F10,	!So, not bothering with F00,
     1  F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,	!Prepare a horde of simple names,
     2  F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,	!which can be initialised
     3  F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,	!in a certain way,
     4  F41,F42,F43,F44,F45				!without scaring the compiler.
       PARAMETER (F01 = 1, F02 = 2, F03 = F02 + F01, F04 = F03 + F02,	!Thusly.
     1  F05=F04+F03,F06=F05+F04,F07=F06+F05,F08=F07+F06,F09=F08+F07,	!Typing all this
     2  F10=F09+F08,F11=F10+F09,F12=F11+F10,F13=F12+F11,F14=F13+F12,	!is an invitation
     3  F15=F14+F13,F16=F15+F14,F17=F16+F15,F18=F17+F16,F19=F18+F17,	!for mistypes.
     4  F20=F19+F18,F21=F20+F19,F22=F21+F20,F23=F22+F21,F24=F23+F22,	!So a regular layout
     5  F25=F24+F23,F26=F25+F24,F27=F26+F25,F28=F27+F26,F29=F28+F27,	!helps a little.
     6  F30=F29+F28,F31=F30+F29,F32=F31+F30,F33=F32+F31,F34=F33+F32,	!Otherwise,
     7  F35=F34+F33,F36=F35+F34,F37=F36+F35,F38=F37+F36,F39=F38+F37,	!devise a prog.
     8  F40=F39+F38,F41=F40+F39,F42=F41+F40,F43=F42+F41,F44=F43+F42,	!to generate these texts...
     9  F45=F44+F43)	!The next is 2971215073. Too big for 32-bit two's complement integers.
       PARAMETER (F1B = (/F01,F02,F03,F04,F05,F06,F07,F08,F09,F10,	!And now,
     1  F11, F12, F13, F14, F15, F16, F17, F18, F19, F20,		!Here is the desired
     2  F21, F22, F23, F24, F25, F26, F27, F28, F29, F30,		!array of constants.
     3  F31, F32, F33, F34, F35, F36, F37, F38, F39, F40,		!And as such, possibly
     4  F41, F42, F43, F44, F45/))					!protected from alteration.
       CONTAINS	!After all that, here we go.
        SUBROUTINE ZECK(N,D)	!Convert N to a "Zeckendorf" digit sequence.
Counts upwards from digit one. D(i) ~ F1B(i). D(0) fingers the high-order digit.
         INTEGER N	!The normal number, in the computer's base.
         INTEGER D(0:)	!The digits, to be determined.
         INTEGER R	!The remnant.
         INTEGER L	!A finger, similar to the power of the base.
          IF (N.LT.0) STOP "ZECK! No negative numbers!"	!I'm not thinking about them.
          R = N		!Grab a copy that I can mess with.
          D = 0		!Scrub the lot in one go.
          L = ZLAST	!As if starting with BASE**MAX, rather than BASE**0.
   10     IF (R.GE.F1B(L)) THEN	!Has the remnant sufficient for this digit?
            R = R - F1B(L)		!Yes! Remove that amount.
            IF (D(0).EQ.0) THEN		!Is this the first non-zero digit?
              IF (L.GT.UBOUND(D,DIM=1)) STOP "ZECK! Not enough digits!"	!Yes.
              D(0) = L			!Remember the location of the high-order digit.
            END IF			!Two loops instead, to avoid repeated testing?
            D(L) = 1			!Place the digit, knowing a place awaits.
            L = L - 1			!Never need a ...11... sequence because F1B(i) + F1B(i+1) = F1B(i+2).
          END IF		!So much for that digit "power".
          L = L - 1		!Down a digit.
          IF (L.GT.0 .AND. R.GT.0) GO TO 10	!Are we there yet?
          IF (N.EQ.0) D(0) = 1	!Zero has one digit.
        END SUBROUTINE ZECK	!That was fun.

        INTEGER FUNCTION ZECKN(D)	!Converts a "Zeckendorf" digit sequence to a number.
         INTEGER D(0:)	!The digits. D(0) fingers the high-order digit.
          IF (D(0).LE.0) STOP "ZECKN! Empty number!"	!General paranoia.
          IF (D(0).GT.ZLAST) STOP "ZECKN! Oversize number!"	!I hate array bound hiccoughs.
          ZECKN = SUM(D(1:D(0))*F1B(1:D(0)))	!This is what positional notation means.
          IF (ZECKN.LT.0) STOP "ZECKN! Integer overflow!"	!Oh for IF OVERFLOW as in First Fortran.
        END FUNCTION ZECKN	!Overflows by a small amount will produce a negative number.
      END MODULE ZECKENDORF ARITHMETIC	!Odd stuff.

      PROGRAM POKE
      USE ZECKENDORF ARITHMETIC	!Please.
      INTEGER ZD(0:ZLAST)	!A scratchpad.
      INTEGER I,J,W
      CHARACTER*1 DIGIT(0:1)	!Assistance for the output.
      PARAMETER (DIGIT = (/"0","1"/), W = 6)	!This field width suffices.
c      WRITE (6,*) F1B
c      WRITE (6,*) INT8(F1B(44)) + INT8(F1B(45))
      WRITE (6,1) F1B(1:4),ZLAST,ZLAST,F1B(ZLAST),HUGE(I)	!Show some provenance.
    1 FORMAT ("Converts integers to their Zeckendorf digit string "
     1 "using the Fib1nacci sequence (",4(I0,","),
     2 " ...) as the equivalent of powers."/
     3 "At most, ",I0," digits because Fib1nacci(",I0,") = ",I0,
     4 " and the integer limit is ",I0,".",//,"  N     ZN")	!Ends with a heading.

      DO I = 0,20	!Step through the specified range.
        CALL ZECK(I,ZD)		!Convert I to ZD.
c       WRITE (6,2) I,ZD(ZD(0):1:-1)	!Show digits from high-order to low.
c   2   FORMAT (I3,1X,66I1)		!Or, WRITE (6,2) I,(ZD(J), J = ZD(0),1,-1)
        WRITE (6,3) I,(" ",J = ZD(0) + 1,W),DIGIT(ZD(ZD(0):1:-1))	!Right-aligned in field width W.
    3   FORMAT (I3,1X,66A1)		!The digits appear as characters.
        IF (I.NE.ZECKN(ZD)) STOP "Huh?"	!Should never happen...
      END DO		!On to the next.

      END
