Crunches a set of hourly data. Starts with a date, then 24 pairs of value,indicator for that day, on one line.
      INTEGER Y,M,D		!Year, month, and day.
      INTEGER GOOD(24)		!The indicators.
      REAL*8 V(24),VTOT,T	!The grist.
      INTEGER NV,N,NB		!Number of good values overall, and in a day.
      INTEGER I,NREC,HIC	!Some counters.
      INTEGER BI,BN,BBI,BBN	!Stuff to locate the longest run of bad data,
      CHARACTER*10 BDATE,BBDATE	!Along with the starting date.
      LOGICAL INGOOD		!State flipper for the runs of data.
      INTEGER IN,MSG		!I/O mnemonics.
      CHARACTER*666 ACARD	!Scratchpad, of sufficient length for all expectation.
      IN = 10		!Unit number for the input file.
      MSG = 6		!Output.
      OPEN (IN,FILE="Readings1.txt", FORM="FORMATTED",	!This should be a function.
     1 STATUS ="OLD",ACTION="READ")			!Returning success, or failure.
      NB = 0		!No bad values read.
      NV = 0		!Nor good values read.
      VTOT = 0		!Their average is to come.
      NREC = 0		!No records read.
      HIC = 0		!Provoking no complaints.
      INGOOD = .TRUE.	!I start in hope.
      BBN = 0		!And the longest previous bad run is short.
Chew into the file.
   10 READ (IN,11,END=100,ERR=666) L,ACARD(1:MIN(L,LEN(ACARD)))	!With some protection.
      NREC = NREC + 1		!So, a record has been read.
   11 FORMAT (Q,A)		!Obviously, Q ascertains the length of the record being read.
      READ (ACARD,12,END=600,ERR=601) Y,M,D	!The date part is trouble, as always.
   12 FORMAT (I4,2(1X,I2))				!Because there are no delimiters between the parts.
      READ (ACARD(11:L),*,END=600,ERR=601) (V(I),GOOD(I),I = 1,24)	!But after the date, delimiters abound.
Calculations. Could use COUNT(array) and SUM(array), but each requires its own pass through the array.
   20 T = 0		!Start on the day's statistics.
      N = 0		!No values yet.
      DO I = 1,24	!So, scan the cargo and do all the twiddling in one pass..
        IF (GOOD(I).GT.0) THEN	!A good value?
          N = N + 1		!Yes. Count it in.
          T = T + V(I)		!And augment for the average.
          IF (.NOT.INGOOD) THEN	!Had we been ungood?
            INGOOD = .TRUE.	!Yes. But now it changes.
            IF (BN.GT.BBN) THEN	!The run just ending: is it longer?
              BBN = BN		!Yes. Make it the new baddest.
              BBI = BI		!Recalling its start index,
              BBDATE = BDATE	!And its start date.
            END IF		!So much for bigger badness.
          END IF		!Now we're in good data.
         ELSE		!Otherwise, a bad value is upon us.
          IF (INGOOD) THEN	!Were we good?
            INGOOD = .FALSE.	!No longer. A new bad run is starting.
            BDATE = ACARD(1:10)	!Recall the date for this starter.
            BI = I		!And its index.
            BN = 0		!Start the run-length counter.
          END IF		!So much for a fall.
          BN = BN + 1	!Count another bad value.
        END IF		!Good or bad, so much for that value.
      END DO		!On to the next.
Commentary for the day's data..
      IF (N.LE.0) THEN	!I prefer to avoid dividing by zero.
        WRITE (MSG,21) NREC,ACARD(1:10)	!So, no average to report.
   21   FORMAT ("Record",I8," (",A,") has no good data!")	!Just a remark.
       ELSE			!But otherwise,
        WRITE(MSG,22) NREC,ACARD(1:10),N,T/N	!An average is possible.
   22   FORMAT("Record",I8," (",A,")",I3," good, average",F9.3)	!So here it is.
        NB = NB + 24 - N	!Count the bad by implication.
        NV = NV + N		!Count the good directly.
        VTOT = VTOT + T		!Should really sum deviations from a working average.
      END IF			!So much for that line.
      GO TO 10		!More! More! I want more!!

Complaints. Should really distinguish between trouble in the date part and in the data part.
  600 WRITE (MSG,*) '"END" declared - insufficient data?'	!Not enough numbers, presumably.
      GO TO 602				!Reveal the record.
  601 WRITE (MSG,*) '"ERR" declared - improper number format?'	!Ah, but which number?
  602 WRITE (MSG,603) NREC,L,ACARD(1:L)	!Anyway, reveal the uninterpreted record.
  603 FORMAT(" Record ",I0,", length ",I0," reads ",A)	!Just so.
      HIC = HIC + 1			!This may grow into a habit.
      IF (HIC.LE.12) GO TO 10		!But if not yet, try the next record.
      STOP "Enough distaste."		!Or, give up.
  666 WRITE (MSG,101) NREC,"format error!"	!For A-style data? Should never happen!
      GO TO 900				!But if it does, give up!

Closedown.
  100 WRITE (MSG,101) NREC,"then end-of-file"	!Discovered on the next attempt.
  101 FORMAT (" Record ",I0,": ",A)		!A record number plus a remark.
      WRITE (MSG,102) NV,NB,VTOT/NV		!The overall results.
  102 FORMAT (I8," values, ",I0," bad. Average",F9.4)	!This should do.
      IF (BBN.LE.0) THEN		!Now for a special report.
        WRITE (MSG,*) "No bad value presented, so no longest run."	!Unneeded!
       ELSE				!But actually, the example data has some bad values.
        WRITE (MSG,103) BBN,BBI,BBDATE	!And this is for the longest encountered.
  103   FORMAT ("Longest bad run: ",I0,", starting hour ",I0," on ",A)	!Just so.
      END IF			!Enough remarks.
  900 CLOSE(IN)		!Done.
      END	!Spaghetti rules.
