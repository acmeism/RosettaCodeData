      SUBROUTINE BDIFF (B1,B2)	!Difference B2 - B1, as bearings. All in degrees, not radians.
       REAL*8 B1,B2	!Maximum precision, for large-angle folding.
       COMPLEX*16 CIS,Z1,Z2,Z	!Scratchpads.
       CIS(T) = CMPLX(COSD(T),SIND(T))	!Convert an angle into a unit vector.
        Z1 = CIS(90 - B1)	!Bearings run clockwise from north (y) around to east (x).
        Z2 = CIS(90 - B2)	!Mathematics runs counterclockwise from x (east).
        Z = Z1*CONJG(Z2)	!(Z1x,Z1y)(Z2x,-Z2y) = (Z1x.Z2x + Z1y.Z2y, Z1y.Z2x - Z1x.Z2y)
        T = ATAN2D(AIMAG(Z),REAL(Z))	!Madly, arctan(x,y) is ATAN(Y,X)!
        WRITE (6,10) B1,Z1,B2,Z2,T	!Two sets of numbers, and a result.
   10   FORMAT (2(F14.4,"(",F9.6,",",F9.6,")"),F9.3)	!Two lots, and a tail.
      END SUBROUTINE BDIFF	!Having functions in degrees saves some bother.

      PROGRAM ORIENTED
      REAL*8 B(24)	!Just prepare a wad of values.
      DATA B/20D0,45D0, -45D0,45D0, -85D0,90D0, -95D0,90D0,	!As specified.
     1      -45D0,125D0, -45D0,145D0, 29.4803D0,-88.6381D0,
     2      -78.3251D0,              -159.036D0,
     3   -70099.74233810938D0,      29840.67437876723D0,
     4  -165313.6666297357D0,       33693.9894517456D0,
     5     1174.8380510598456D0,  -154146.66490124757D0,
     6    60175.77306795546D0,      42213.07192354373D0/

      WRITE (6,1) ("B",I,"x","y", I = 1,2)	!Or, one could just list them twice.
    1 FORMAT (28X,"Bearing calculations, in degrees"//
     * 2(A13,I1,"(",A9,",",A9,")"),A9)	!Compare format 10, above.

      DO I = 1,23,2	!Step through the pairs.
        CALL BDIFF(B(I),B(I + 1))
      END DO

      END
