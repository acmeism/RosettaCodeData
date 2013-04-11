C     WARNING: This program is not valid ANSI FORTRAN 77 code. It uses
C     one nonstandard character on the line labelled 5001. Many F77
C     compilers should be okay with it, but it is *not* standard.
C
C     It is also worth noting that FORTRAN 77 uses the command CONTINUE,
C     but not in the semantic, looping sense of the word. In FORTRAN,
C     CONTINUE means "do absolutely nothing." It is a placeholder. If
C     anything, it means "continue to the next line."
C
C     Python does the same thing with `pass`; C and its family of
C     languages, with `{/* do nothing */}`. Write CONTINUE when you need
C     to write something but have nothing to write.
C
C     This page on Rosetta Code is about a very different "continue"
C     statement that tells a loop to go back to the beginning. In
C     FORTRAN, we use (you guessed it!) a GOTO to accomplish this.
      PROGRAM CONTINUELOOP
        INTEGER I

        DO 10 I = 1, 10
C         Is it five or ten?
          IF (MOD(I, 5) .EQ. 0) THEN
C           If it is, write a newline and no comma.
            WRITE (*,5000) I

C           Continue the loop; that is, skip to the end of the loop.
            GOTO 10
          ENDIF

C         Write I with a comma and no newline.
          WRITE (*,5001) I

C       Again, in this case, CONTINUE is completely unrelated to the
C       semantic, looping sense of the word.
   10   CONTINUE

        STOP

C       This will print an integer and a newline (no comma).
 5000   FORMAT (I3)

C       Standard FORTRAN 77 is completely incapable of completing a
C       WRITE statement without printing a newline. If you want to print
C       five integers in standard code, you have to do something like
C       this:
C
C           FORMAT (I3, ',', I3, ',', I3, ',', I3, ',', I3)
C
C       Writing `1, 2, 3, 4, 5` and then `6, 7, 8, 9, 10` to that format
C       would produce the following two lines:
C
C             1,  2,  3,  4,  5
C             6,  7,  8,  9, 10
C
C       However, this code exists to demonstrate continuing a FORTRAN 77
C       loop and not to demonstrate how to get around its rigidity about
C       newlines.
C
C       The dollar sign at the end of the format is a nonstandard
C       character. It tells the compiler not to print a newline. If you
C       are actually using FORTRAN 77, you should figure out what your
C       particular compiler accepts. If you are actually using Fortran
C       90 or later, you should replace this line with the commented
C       line that follows it.
 5001   FORMAT (I3, ',', $)
C5001   FORMAT (I3, ',', ADVANCE='NO')
      END
