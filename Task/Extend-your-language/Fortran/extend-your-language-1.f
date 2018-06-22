      LOGICAL A,B		!These are allocated the same storage
      INTEGER IA,IB		!As the default integer size.
      EQUIVALENCE (IA,A),(IB,B)	!So, this will cause no overlaps.

      WRITE (6,*) "Boolean tests via integers..."
      DO 199 IA = 0,1	!Two states for A.
        DO 199 IB = 0,1		!Two states for B.
          IF (IA) 666,99,109		!Not four ways, just three.
   99     IF (IB) 666,100,101		!Negative values are surely wrong.
  100     WRITE (6,*) "FF",IA,IB
          GO TO 199
  101     WRITE (6,*) "FT",IA,IB
          GO TO 199
  109     IF (IB) 666,110,111		!A second test.
  110     WRITE (6,*) "TF",IA,IB
          GO TO 199
  111     WRITE (6,*) "TT",IA,IB
  199 CONTINUE		!Both loops finish here.

      WRITE (6,*) "Boolean tests via integers and computed GO TO..."
      DO 299 IA = 0,1	!Two states for A.
        DO 299 IB = 0,1		!Two states for B.
          GO TO (200,201,210,211) 1 + IA*2 + IB	!Counting starts with one.
  200     WRITE (6,*) "FF",IA,IB
          GO TO 299
  201     WRITE (6,*) "FT",IA,IB
          GO TO 299
  210     WRITE (6,*) "TF",IA,IB
          GO TO 299
  211     WRITE (6,*) "TT",IA,IB
  299 CONTINUE		!Both loops finish here.

  300 WRITE (6,301)
  301 FORMAT (/,"Boolean tests via LOGICAL variables...",/
     1 " AB    IA    IB (IA*2 + IB)")
      A = .TRUE.	!Syncopation.
      B = .TRUE.	!Via the .NOT., the first pair will be FF.
      DO I = 0,1	!Step through two states.
        A = .NOT.A		!Thus generate F then T.
        DO J = 0,1		!Step through the second two states.
          B = .NOT.B			!Thus generate FF, FT, TF, TT.
          WRITE (6,302) A,B,IA,IB,IA*2 + IB	!But with strange values.
  302     FORMAT (1X,2L1,2I6,I8)		!Show both types.
        END DO			!Next value for B.
      END DO		!Next value for A.
      GO TO 999

  666 WRITE (6,*) "Huh?"

  999 CONTINUE
      END
