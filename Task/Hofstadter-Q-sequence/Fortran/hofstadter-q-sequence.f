Calculate the Hofstadter Q-sequence, using a big array rather than recursion.
      INTEGER ENUFF
      PARAMETER (ENUFF = 100000)
      INTEGER Q(ENUFF)	!Lots of memory these days.

      Q(1) = 1		!Initial values as per the definition.
      Q(2) = 1
      Q(3:) = -123456789!This will surely cause trouble!
      DO I = 3,ENUFF	!For values beyond the second,
        Q(I) = Q(I - Q(I - 1)) + Q(I - Q(I - 2))	!Reach back according to the last two values.
      END DO
Cast forth results as per the specification.
      WRITE (6,1) Q(1:10)		!Should be 1 1 2 3 3 4 5 5 6 6...
    1 FORMAT ("First ten values:",10I2)	!Known to be one-digit numbers.
      WRITE (6,*) "Q(1000) =",Q(1000)	!Should be 502.
      WRITE (6,3) ENUFF,COUNT(Q(2:ENUFF) < Q(1:ENUFF - 1))	!Please don't create a temporary array!
    3 FORMAT ("Count of those elements 2:",I0,
     1 " which are less than their predecessor: ",I0)	!Should be 49798.
Curry favour by allowing enquiries.
   10 WRITE (6,11) ENUFF
   11 FORMAT ("Nominate an index (in 1:",I0,"): ",$)	!Obviously, the $ says don't start a new line.
      READ (5,*,END = 999, ERR = 999) I	!Ask for a number, with precautions.
      IF (I.GT.0 .AND. I.LE.ENUFF) THEN	!A good number, but, within range?
        WRITE (6,12) I,Q(I)		!Yes. Reveal the requested value.
   12   FORMAT ("Q(",I0,") = ",I0)	!This should do.
        GO TO 10			!And ask again.
      END IF		! WHILE read(5,*) i & i > 0 & i < enuff DO write(6,*) "Q(",i,")=",Q(i);
Closedown.
  999 WRITE (6,*) "Bye."
      END
