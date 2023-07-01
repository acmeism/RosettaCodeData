      SIZE = 4     : MAX = SIZE-1
      Won% = FALSE : Lost% = FALSE
      @% = 5
      DIM Board(MAX,MAX),Stuck% 3

      PROCBreed
      PROCPrint
      REPEAT
        Direction = GET-135
        IF Direction > 0 AND Direction < 5 THEN
          Moved% = FALSE
          PROCShift
          PROCMerge
          PROCShift
          IF Moved% THEN PROCBreed : !Stuck%=0 ELSE ?(Stuck%+Direction-1)=-1 : Lost% = !Stuck%=-1
          PROCPrint
        ENDIF
      UNTIL Won% OR Lost%
      IF Won% THEN PRINT "You WON! :-)" ELSE PRINT "You lost :-("
      END

      REM -----------------------------------------------------------------------------------------------------------------------
      DEF PROCPrint
      FOR i = 0 TO SIZE*SIZE-1
        IF Board(i DIV SIZE,i MOD SIZE) THEN PRINT Board(i DIV SIZE,i MOD SIZE); ELSE PRINT "    _";
        IF i MOD SIZE = MAX THEN PRINT
      NEXT
      PRINT STRING$(SIZE,"-----")
      ENDPROC

      REM ----------------------------------------------------------------------------------------------------------------------
      DEF PROCShift
      IF Direction = 2 OR Direction = 3 THEN loopend = MAX : step = -1 ELSE loopend = 0 : step = 1
      FOR row = loopend TO MAX-loopend STEP step
        zeros = 0
        FOR col = loopend TO MAX-loopend STEP step
          IF Direction < 3 THEN
            IF Board(row,col) = 0 THEN zeros += step ELSE IF zeros THEN SWAP Board(row,col),Board(row,col-zeros) : Moved% = TRUE
          ELSE
            IF Board(col,row) = 0 THEN zeros += step ELSE IF zeros THEN SWAP Board(col,row),Board(col-zeros,row) : Moved% = TRUE
          ENDIF
        NEXT
      NEXT
      ENDPROC

      REM -----------------------------------------------------------------------------------------------------------------------
      DEF PROCMerge
      IF Direction = 1 THEN loopend =   0 : rowoff =  0 : coloff =  1 : step =  1
      IF Direction = 2 THEN loopend = MAX : rowoff =  0 : coloff = -1 : step = -1
      IF Direction = 3 THEN loopend = MAX : rowoff = -1 : coloff =  0 : step = -1
      IF Direction = 4 THEN loopend =   0 : rowoff =  1 : coloff =  0 : step =  1
      FOR row = loopend TO MAX-loopend-rowoff STEP step
        FOR col = loopend TO MAX-loopend-coloff STEP step
          IF Board(row,col) THEN IF Board(row,col) = Board(row+rowoff,col+coloff) THEN
            Board(row,col) *= 2 : Board(row+rowoff,col+coloff) = 0
            Moved% = TRUE
            IF NOT Won% THEN Won% = Board(row,col)=2048
          ENDIF
        NEXT
      NEXT
      ENDPROC

      REM -----------------------------------------------------------------------------------------------------------------------
      DEF PROCBreed
      cell = RND(SIZE*SIZE)-1
      FOR i = 0 TO SIZE*SIZE-1
        z = (cell+i) MOD (SIZE*SIZE)
        IF Board(z DIV SIZE,z MOD SIZE) = 0 THEN Board(z DIV SIZE,z MOD SIZE) = 2-(RND(10)=1)*2 : EXIT FOR
      NEXT
      ENDPROC
