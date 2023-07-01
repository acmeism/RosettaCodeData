Copies a file with 5 comma-separated values to a line, appending a column holding their sum.
      INTEGER N			!Instead of littering the source with "5"
      PARAMETER (N = 5)		!Provide some provenance.
      CHARACTER*6 HEAD(N)	!A perfect size?
      INTEGER X(N)		!Integers suffice.
      INTEGER LINPR,IN		!I/O unit numbers.
      LINPR = 6		!Standard output via this unit number.
      IN = 10		!Some unit number for the input file.
      OPEN (IN,FILE="CSVtest.csv",STATUS="OLD",ACTION="READ")	!For formatted input.

      READ (IN,*) HEAD	!The first line has texts as column headings.
      WRITE (LINPR,1) (TRIM(HEAD(I)), I = 1,N),"Sum"	!Append a "Sum" column.
    1 FORMAT (666(A:","))	!The : sez "stop if no list element awaits".
    2 READ (IN,*,END = 10) X	!Read a line's worth of numbers, separated by commas or spaces.
      WRITE (LINPR,3) X,SUM(X)	!Write, with a total appended.
    3 FORMAT (666(I0:","))	!I0 editing uses only as many columns as are needed.
      GO TO 2			!Do it again.

   10 CLOSE (IN)	!All done.
      END	!That's all.
