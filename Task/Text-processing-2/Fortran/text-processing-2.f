Crunches a set of hourly data. Starts with a date, then 24 pairs of value,indicator for that day, on one line.
      INTEGER Y,M,D		!Year, month, and day.
      INTEGER GOOD(24,2)	!The indicators.
      REAL*8     V(24,2)	!The grist.
      CHARACTER*10 DATE(2)	!Along with the starting date.
      INTEGER IT,TI		!A flipper and its antiflipper.
      INTEGER NV		!Number of entirely good records.
      INTEGER I,NREC,HIC	!Some counters.
      LOGICAL INGOOD		!State flipper for the runs of data.
      INTEGER IN,MSG		!I/O mnemonics.
      CHARACTER*666 ACARD	!Scratchpad, of sufficient length for all expectation.
      IN = 10		!Unit number for the input file.
      MSG = 6		!Output.
      OPEN (IN,FILE="Readings1.txt", FORM="FORMATTED",	!This should be a function.
     1 STATUS ="OLD",ACTION="READ")			!Returning success, or failure.
      NV = 0		!No pure records seen.
      NREC = 0		!No records read.
      HIC = 0		!Provoking no complaints.
      DATE = "snargle"	!No date should look like this!
      IT = 2		!Syncopation for the 1-2 flip flop.
Chew into the file.
   10 READ (IN,11,END=100,ERR=666) L,ACARD(1:MIN(L,LEN(ACARD)))	!With some protection.
      NREC = NREC + 1		!So, a record has been read.
   11 FORMAT (Q,A)		!Obviously, Q ascertains the length of the record being read.
      READ (ACARD,12,END=600,ERR=601) Y,M,D	!The date part is trouble, as always.
   12 FORMAT (I4,2(1X,I2))				!Because there are no delimiters between the parts.
      TI = IT			!Thus finger the previous value.
      IT = 3 - IT		!Flip between 1 and 2.
      DATE(IT) = ACARD(1:10)	!Save the date field.
      READ (ACARD(11:L),*,END=600,ERR=601) (V(I,IT),GOOD(I,IT),I = 1,24)	!But after the date, delimiters abound.
Comparisons. Should really convert the date to a daynumber, check it by reversion, and then check for + 1 day only.
   20 IF (DATE(IT).EQ.DATE(TI)) THEN	!Same date?
        IF (ALL(V(:,IT)   .EQ.V(:,TI)) .AND.	!Yes. What about the data?
     1      ALL(GOOD(:,IT).EQ.GOOD(:,TI))) THEN	!This disregards details of the spacing of the data.
          WRITE (MSG,21) NREC,DATE(IT),"same."	!Also trailing zeroes, spurious + signs, blah blah.
   21     FORMAT ("Record",I8," Duplicate date field (",A,"), data ",A)	!Say it.
         ELSE				!But if they're not all equal,
          WRITE (MSG,21) NREC,DATE(IT),"different!"	!They're different!
        END IF					!So much for comparing the data.
      END IF				!So much for just comparing the date's text.
      IF (ALL(GOOD(:,IT).GT.0)) NV = NV + 1	!A fully healthy record, either way?
      GO TO 10		!More! More! I want more!!

Complaints. Should really distinguish between trouble in the date part and in the data part.
  600 WRITE (MSG,*) '"END" declared - insufficient data?'	!Not enough numbers, presumably.
      GO TO 602				!Reveal the record.
  601 WRITE (MSG,*) '"ERR" declared - improper number format?'	!Ah, but which number?
  602 WRITE (MSG,603) NREC,L,ACARD(1:L)	!Anyway, reveal the uninterpreted record.
  603 FORMAT("Record",I8,", length ",I0," reads ",A)	!Just so.
      HIC = HIC + 1			!This may grow into a habit.
      IF (HIC.LE.12) GO TO 10		!But if not yet, try the next record.
      STOP "Enough distaste."		!Or, give up.
  666 WRITE (MSG,101) NREC,"format error!"	!For A-style data? Should never happen!
      GO TO 900				!But if it does, give up!

Closedown.
  100 WRITE (MSG,101) NREC,"then end-of-file"	!Discovered on the next attempt.
  101 FORMAT ("Record",I8,": ",A)		!A record number plus a remark.
      WRITE (MSG,102) NV	!The overall results.
  102 FORMAT ("  with",I8," having all values good.")	!This should do.
  900 CLOSE(IN)		!Done.
      END	!Spaghetti rules.
