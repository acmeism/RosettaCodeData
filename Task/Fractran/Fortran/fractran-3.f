      DO I = 1,M		!Here we go!
        IT = FRACTRAN(N,P,Q,L)		!Do it!
        IF (POPCNT(N).EQ.1) WRITE (6,11) I,IT,N		!Show it!
   11   FORMAT (I6,I4,": ",I0)		!N last, as it may be big.
        IF (IT.LE.0) EXIT		!No hit, so quit.
        IF (N.LE.0) THEN		!Otherwise, worry about overflow.
          WRITE (6,*) "Integer overflow!"	!Justified. The test is not certain.
          WRITE (6,11) I,IT,N			!Alas, the step failed.
          EXIT					!Give in.
        END IF				!So much for overflow.
      END DO			!The next step.
