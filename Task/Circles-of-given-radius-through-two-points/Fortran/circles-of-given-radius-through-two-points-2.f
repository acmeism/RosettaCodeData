      MODULE GEOMETRY	!Limited scope.
       CHARACTER*(*) SQUAWK(-3:2)	!Holds a schedule of complaints.
       PARAMETER (SQUAWK = (/		!According to what might go wrong.
     3  "No circles: points are more than 2R apart.",
     2  "Innumerable circles: co-incident points, R > 0.",
     1  "One 'circle', centred on the co-incident points. R is zero!",
     o  "No circles! R is negative!",
     1  "One circle: points are 2R apart.",
     2  "Two circles."/))		!This last is the hoped-for state.
      CONTAINS	!Now for the action.
       SUBROUTINE BUBBLE(P,R,N)	!Finds circles of radius R passing through two points.
        COMPLEX P(2)	!The two points. Results returned here.
        REAL R		!The specified radius.
        INTEGER N	!Indicates how many centres are valid.
        COMPLEX MID,DP	!Geometrical assistants.
         DP = (P(2) - P(1))/2	!Or, the other way around.
         D = ABS(DP)		!Half the separation is useful.
         IF (R.LT.0) THEN	!Is the specified radius silly?
           N =  0			!Yes. No circles, then.
         ELSE IF (D.EQ.0) THEN	!Any distance between the points?
           IF (R.EQ.0) THEN		!No. Zero radius?
             N = -1				!Yes. So a degenerate "circle" of zero radius.
            ELSE			!A negative radius being tested for above,
             N = -2				!A swirl of circles around the midpoint.
           END IF		!So much for co-incident points.
         ELSE IF (D.GT.R) THEN	!Points too far apart?
           N = -3			!A circle of radius R can't reach them.
         ELSE IF (D.EQ.R) THEN	!Maximum separation for R?
           N = 1			!Yes. The two circles lie atop each other.
           P(1) = (P(1) + P(2))/2	!Both centres are on the midpoint, but N = 1.
         ELSE			!Finally, the ordinary case.
           N = 2			!Two circles.
           MID = (P(1) + P(2))/2	!Midway between the two points.
           D = SQRT((R/D)**2 - 1)	!Rescale vector DP.
           P = MID + DP*CMPLX(0,(/+D,-D/))	!Array (0,+D), (0,-D)
         END IF				!P(1) = DP*CMPLX(0,+D) and P(2) = DP*CMPLX(0,-D)
       END SUBROUTINE BUBBLE	!Careful! P and N are modified.
      END MODULE GEOMETRY	!Not much.

      PROGRAM POKE	!A tester.
      USE GEOMETRY	!Useful to I. Newton.
      COMPLEX P(2)		!A pair of points.
      REAL PP(4)		!Also a pair.
      EQUIVALENCE (P,PP)	!Since free-format input likes (x,y), not x,y
      REAL R			!This is not complex.
      INTEGER MSG,IN		!I/O unit numbers.
      MSG = 6			!Standard output.
      OPEN (MSG, RECL = 120)	!For "formatted" files, this length is in characters.
      IN = 10			!For the disc file holding the test data.
      WRITE (MSG,1)		!Announce.
    1 FORMAT ("Given two points and a radius, find the centres "
     1 "of circles of that radius passing through those points.")

      OPEN (IN,FILE="Circle.csv", STATUS = "OLD", ACTION="READ")	!Have data, will compute.
   10 READ (IN,*,END = 20) PP,R		!Get two points and a radius.
      WRITE (MSG,*)			!Set off.
      WRITE (MSG,*) P,R			!Show the input.
      CALL BUBBLE(P,R,N)		!Calculate.
      WRITE (MSG,*) P(1:N),SQUAWK(N)	!Show results.
      GO TO 10				!Try it again.

   20 CLOSE(IN)		!Finihed with input.
      END	!Finished.
