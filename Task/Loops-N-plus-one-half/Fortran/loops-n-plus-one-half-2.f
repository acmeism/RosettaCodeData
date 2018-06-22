C     WARNING: This program is not valid ANSI FORTRAN 77 code. It uses
C     two nonstandard characters on the lines labelled 5001 and 5002.
C     Many F77 compilers should be okay with it, but it is *not*
C     standard.
      PROGRAM LOOPPLUSONEHALF
        INTEGER I, TEN
C       I'm setting a parameter to distinguish from the label 10.
        PARAMETER (TEN = 10)

        DO 10 I = 1, TEN
C         Write the number only.
          WRITE (*,5001) I

C         If we are on the last one, stop here. This will make this test
C         every iteration, which can slow your program down a little. If
C         you want to speed this up at the cost of your own convenience,
C         you could loop only to nine, and handle ten on its own after
C         the loop is finished. If you don't care, power to you.
          IF (I .EQ. TEN) GOTO 10

C         Append a comma to the number.
          WRITE (*,5002) ','
   10   CONTINUE

C       Always finish with a newline. This programmer hates it when a
C       program does not end its output with a newline.
        WRITE (*,5000) ''
        STOP

 5000   FORMAT (A)

C       Standard FORTRAN 77 is completely incapable of completing a
C       WRITE statement without printing a newline. This program would
C       be much more difficult (i.e. impossible) to write in the ANSI
C       standard, without cheating and saying something like:
C
C           WRITE (*,*) '1, 2, 3, 4, 5, 6, 7, 8, 9, 10'
C
C       The dollar sign at the end of the format is a nonstandard
C       character. It tells the compiler not to print a newline. If you
C       are actually using FORTRAN 77, you should figure out what your
C       particular compiler accepts. If you are actually using Fortran
C       90 or later, you should replace this line with the commented
C       line that follows it.
 5001   FORMAT (I3, $)
 5002   FORMAT (A, $)
C5001   FORMAT (T3, ADVANCE='NO')
C5001   FORMAT (A, ADVANCE='NO')
      END
