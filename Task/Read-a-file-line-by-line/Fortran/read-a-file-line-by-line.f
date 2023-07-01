      INTEGER ENUFF		!A value has to be specified beforehand,.
      PARAMETER (ENUFF = 2468)	!Provide some provenance.
      CHARACTER*(ENUFF) ALINE	!A perfect size?
      CHARACTER*66 FNAME	!What about file name sizes?
      INTEGER LINPR,IN		!I/O unit numbers.
      INTEGER L,N		!A length, and a record counter.
      LOGICAL EXIST		!This can't be asked for in an "OPEN" statement.
      LINPR = 6			!Standard output via this unit number.
      IN = 10			!Some unit number for the input file.
      FNAME = "Read.for"	!Choose a file name.
      INQUIRE (FILE = FNAME, EXIST = EXIST)	!A basic question.
      IF (.NOT.EXIST) THEN		!Absent?
        WRITE (LINPR,1) FNAME		!Alas, name the absentee.
    1   FORMAT ("No sign of file ",A)	!The name might be mistyped.
        STOP "No file, no go."		!Give up.
      END IF				!So much for the most obvious mishap.
      OPEN (IN,FILE = FNAME, STATUS = "OLD", ACTION = "READ")	!For formatted input.

      N = 0		!No records read so far.
   10 READ (IN,11,END = 20) L,ALINE(1:MIN(L,ENUFF))	!Read only the L characters in the record, up to ENUFF.
   11 FORMAT (Q,A)		!Q = "how many characters yet to be read", A = characters with no limit.
      N = N + 1			!A record has been read.
      IF (L.GT.ENUFF) WRITE (LINPR,12) N,L,ENUFF	!Was it longer than ALINE could accommodate?
   12 FORMAT ("Record ",I0," has length ",I0,": my limit is ",I0)	!Yes. Explain.
      WRITE (LINPR,13) N,ALINE(1:MIN(L,ENUFF))	!Print the record, prefixed by the count.
   13 FORMAT (I9,":",A)		!Fixed number size for alignment.
      GO TO 10			!Do it again.

   20 CLOSE (IN)	!All done.
      END	!That's all.
