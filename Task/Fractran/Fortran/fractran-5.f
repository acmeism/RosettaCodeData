      DO I = 1,MS	!Here we go!
        IT = FRACTRAN(LF)	!Do it!
        IF (ALL(NPPOW(2:LP).EQ.0)) CALL SHOWN(I,IT)	!Show it!
        IF (IT.LE.0) EXIT	!Quit it?
      END DO		!The next step.
