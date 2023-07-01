      MODULE GREEK MATHEMATICIANS	!Two millenia back and more.
       CONTAINS
        INTEGER FUNCTION GCD(I,J)	!Greatest common divisor.
         INTEGER I,J	!Of these two integers.
         INTEGER N,M,R	!Workers.
          N = MAX(I,J)	!Since I don't want to damage I or J,
          M = MIN(I,J)	!These copies might as well be the right way around.
    1     R = MOD(N,M)		!Divide N by M to get the remainder R.
c          write (6,*) "M,N,R",M,N,R
          IF (R.GT.0) THEN	!Remainder zero?
            N = M			!No. Descend a level.
            M = R			!M-multiplicity has been removed from N.
            IF (R .GT. 1) GO TO 1	!No point dividing by one.
          END IF			!If R = 0, M divides N.
          GCD = M			!There we are.
        END FUNCTION GCD	!Euclid lives on!
        FUNCTION GCD3(I,J,K)	!Double do.
         INTEGER I,J,K	!Three numbers.
         INTEGER R	!One remainder.
          R = GCD(I,J)		!Greatest common divisor.
          IF (R .GT. 1) R = GCD(R,K)	!The first two might be co-prime.
          GCD3 = R		!The result.
        END FUNCTION GCD3

        REAL*8 FUNCTION HERO(SIDE)	!Hero's calculation for the area of a triangle.
Calculations could proceed with non-integer sides.
         INTEGER SIDE(3)	!The lengths of each of the sides.
         REAL*8 S		!A scratchpad.
          S = SUM(SIDE)		!Definitely integer arithmetic.
          S = S/2		!Full precision without muttering /2D0.
          S = S*PRODUCT(S - SIDE)	!Negative for non-joining triangles.
          HERO = SIGN(SQRT(ABS(S)),S)	!Protect the SQRT against such.
        END FUNCTION HERO		!As when one side is longer than the other two combined.
      END MODULE GREEK MATHEMATICIANS	!Only a selection here.

      PROGRAM TEST		!Find triangles with integral sides and areas.
      USE GREEK MATHEMATICIANS	!For guidance.
      INTEGER LIMIT,LOTS	!And then descend to Furrytran.
      PARAMETER (LIMIT = 200, LOTS = 666)	!This should do.
      INTEGER I,J,K,SIDE(3)	!The lengths of the sides of the triangles.
      EQUIVALENCE (SIDE(1),I),(SIDE(2),J),(SIDE(3),K)	!I want two access styles.
      REAL*8 A			!The area of the triangle.
      TYPE ABLOB		!Define a stash for the desired results.
       INTEGER SIDE(3)		!The three sides,
       INTEGER PERIMETER	!Their summation, somewhat redundant.
       INTEGER AREA		!This is rather more difficult to calculate.
      END TYPE ABLOB		!That will do.
      TYPE(ABLOB) STASH(LOTS)	!I'll have some.
      INTEGER N,XNDX(LOTS)	!A counter and an index..
      INTEGER H,T		!Stuff for the in-line combsort.
      LOGICAL CURSE		!Rather than mess with subroutines and parameters.
      INTEGER TASTE,CHOICE	!Output selection stuff.
      PARAMETER (TASTE = 10, CHOICE = 210)	!As specified.

Collect some triangles.
      N = 0	!So, here we go.
      DO K = 1,LIMIT	!Just slog away,
        DO J = 1,K		!With brute force and ignorance.
          DO I = 1,J			!This way, a 3,4,5 triangle is in that order.
            IF (GCD3(I,J,K).GT.1) CYCLE	!A mere multiple. Seen it before.
            A = HERO(SIDE)		!Assess the area.
            IF (A.LE.0) CYCLE		!Not a valid triangle!
            IF (A .NE. INT(A)) CYCLE	!Not an integral area. Precision is adequate...
            N = N + 1			!Another candidate survives.
            IF (N.GT.LOTS) STOP "Too many!"	!Perhaps not for long!
            XNDX(N) = N			!So, keep a finger.
            STASH(N).SIDE = SIDE		!Stash its details.
            STASH(N).PERIMETER = SUM(SIDE)	!Calculate once, here.
            STASH(N).AREA = A			!And save this as an integer.
c            WRITE (6,10) N,STASH(N)
   10       FORMAT (I4,":",3I4,I7,I8)	!A reasonable layout.
          END DO
        END DO
      END DO
      WRITE (6,11) N,LIMIT	!The first result.
   11 FORMAT (I0," triangles of integral area. Sides up to ",I0)

Comb sort involves coding only one test, and the comparison is to be compound...
      H = N - 1	!Last - First, and not +1.
   20 H = MAX(1,H*10/13)	!The special feature.
      IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
      CURSE = .FALSE.		!So far, so good.
      DO 24 I = N - H,1,-1	!If H = 1, this is a BubbleSort.
        IF (STASH(XNDX(I)).AREA - STASH(XNDX(I + H)).AREA) 24,21,23 	!One compare. But, a compound key.
   21   IF (STASH(XNDX(I)).PERIMETER-STASH(XNDX(I+H)).PERIMETER)24,22,23 	!Equal area, so, perimeter?
   22   IF (MAXVAL(STASH(XNDX(I)).SIDE)			!Equal perimeter, so, longest side?
     1    - MAXVAL(STASH(XNDX(I+H)).SIDE)) 24,24,23	!At last, equality here can be passed over.
   23     T=XNDX(I); XNDX(I)=XNDX(I+H); XNDX(I+H)=T	!One swap.
          CURSE = .TRUE.			!One curse.
   24 CONTINUE				!One loop.
      IF (CURSE .OR. H.GT.1) GO TO 20	!Work remains?

Cast forth the results, as per the specification.
      WRITE (6,30) TASTE
   30 FORMAT ("First ",I0,", ordered by area, perimeter, longest side.",
     1 /,"Index ---Sides--- Perimeter Area")
      DO I = 1,TASTE
        WRITE (6,10) XNDX(I),STASH(XNDX(I))
      END DO

      WRITE (6,31) CHOICE
   31 FORMAT ("Those triangles with area",I7)
      DO I = 1,N	!I could go looking through the ordered list for CHOICE entries,
        IF (STASH(XNDX(I)).AREA.NE.CHOICE) CYCLE!But I can't be bothered.
        WRITE (6,10) XNDX(I),STASH(XNDX(I))	!Here is one such.
      END DO		!Just thump through the lot.
      END
