      DOUBLE PRECISION FUNCTION AREA(N,P)	!Calculates the area enclosed by the polygon P.
C   Uses the mid-point rule for integration. Consider the line joining (x1,y1) to (x2,y2)
C The area under that line (down to the x-axis) is the y-span midpoint (y1 + y2)/2 times the width (x2 - x1)
C This is the trapezoidal rule for a single interval, and follows from simple geometry.
C Now consider a sequence of such points heading in the +x direction: each successive interval's area is positive.
C Follow with a sequence of points heading in the -x direction, back to the first point: their areas are all negative.
C The resulting sum is the area below the +x sequence and above the -x sequence: the area of the polygon.
C   The point sequence can wobble as it wishes and can meet the other side, but it must not cross itself
c as would be done in a figure 8 drawn with a crossover instead of a meeting.
C   A clockwise traversal (as for an island) gives a positive area; use anti-clockwise for a lake.
       INTEGER N		!The number of points.
       DOUBLE COMPLEX P(N)	!The points.
       DOUBLE COMPLEX PP,PC	!Point Previous and Point Current.
       DOUBLE COMPLEX W		!Polygon centre. Map coordinates usually have large offsets.
       DOUBLE PRECISION A	!The area accumulator.
       INTEGER I		!A stepper.
        IF (N.LT.3) STOP "Area: at least three points are needed!"	!Good grief.
        W = (P(1) + P(N/3) + P(2*N/3))/3	!An initial working average.
        W = SUM(P(1:N) - W)/N + W	!A good working average is the average itself.
        A = 0			!The area enclosed by the point sequence.
        PC = P(N) - W		!The last point is implicitly joined to the first.
        DO I = 1,N		!Step through the positions.
          PP = PC			!Previous position.
          PC = P(I) - W			!Current position.
          A = (DIMAG(PC) + DIMAG(PP))*(DBLE(PC) - DBLE(PP)) + A	!Area integral component.
        END DO			!On to the next position.
        AREA = A/2		!Divide by two once.
      END FUNCTION AREA		!The units are those of the points.

      DOUBLE PRECISION FUNCTION AREASL(N,P)	!Area enclosed by polygon P, by the "shoelace" method.
       INTEGER N		!The number of points.
       DOUBLE COMPLEX P(N)	!The points.
       DOUBLE PRECISION A	!A scratchpad.
        A = SUM(DBLE(P(1:N - 1)*DIMAG(P(2:N)))) + DBLE(P(N))*DIMAG(P(1))
     1    - SUM(DBLE(P(2:N)*DIMAG(P(1:N - 1)))) - DBLE(P(1))*DIMAG(P(N))
        AREASL = A/2		!The midpoint formula requires a halving.
      END FUNCTION AREASL	!Negative for clockwise, positive for anti-clockwise.

      INTEGER ENUFF
      DOUBLE PRECISION AREA,AREASL	!The default types are not correct.
      DOUBLE PRECISION A1,A2		!Scratchpads, in case of a debugging WRITE within the functions.
      PARAMETER (ENUFF = 5)		!The specification.
      DOUBLE COMPLEX POINT(ENUFF)	!Could use X and Y arrays instead.
      DATA POINT/(3D0,4D0),(5D0,11D0),(12D0,8D0),(9D0,5D0),(5D0,6D0)/	!"D" for double precision.

      WRITE (6,*) POINT
      A1 = AREA(5,POINT)
      A2 = AREASL(5,POINT)
      WRITE (6,*) "A=",A1,A2
      END
