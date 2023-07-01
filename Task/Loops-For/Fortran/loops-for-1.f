C     WARNING: This program is not valid ANSI FORTRAN 77 code. It uses
C     one nonstandard character on the line labelled 5001. Many F77
C     compilers should be okay with it, but it is *not* standard.
      PROGRAM FORLOOP
        INTEGER I, J

        DO 20 I = 1, 5
          DO 10 J = 1, I
C           Print the asterisk.
            WRITE (*,5001) '*'
   10     CONTINUE
C         Print a newline.
          WRITE (*,5000) ''
   20   CONTINUE

        STOP

 5000   FORMAT (A)
C       Standard FORTRAN 77 is completely incapable of completing a
C       WRITE statement without printing a newline. If you wanted to
C       write this program in valid F77, you would have to come up with
C       a creative way of printing varying numbers of asterisks in a
C       single write statement.
C
C       The dollar sign at the end of the format is a nonstandard
C       character. It tells the compiler not to print a newline. If you
C       are actually using FORTRAN 77, you should figure out what your
C       particular compiler accepts. If you are actually using Fortran
C       90 or later, you should replace this line with the commented
C       line that follows it.
 5001   FORMAT (A, $)
C5001   FORMAT (A, ADVANCE='NO')
      END
