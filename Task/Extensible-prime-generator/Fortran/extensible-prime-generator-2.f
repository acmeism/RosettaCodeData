      MODULE PRIMEBAG	!Need prime numbers? Plenty are available.
C   Creates and expands a disc file for a sieve of Eratoshenes, representing odd numbers only and starting with three.
C   Storage requirements: an array of N prime numbers in 16/32/64 bits vs. a bit array up to the 16/32/64 bit limit.
C Word size               N            Prime   N words in bits           Bit array in bits.
C     8 bit            P(31) =           127               248                         128
C                      P(54) =           251               432                         256
C    16 bit         P(3,512) =        32,749            56,192                      32,768
C                   P(6,542) =        65,521           104,672                      65,536
C    32 bit   P(105,097,565) = 2,147,483,647     3,363,122,080               2,147,483,648
C             P(203,280,221) = 4,294,967,291     6,504,967,072               4,294,967,296
C    64 bit        2.112E17                ?          1.352E19   9,223,372,036,854,775,808 ~ 9.22E18
C from n/Ln(n)     4.158E17                ?          2.661E19  18,446,744,073,709,551,616 ~ 1.84E19
       INTEGER MSG	!I/O unit number.
       INTEGER SSTASH	!For attachment to my stash file.
       INTEGER SRECLEN,SCHARS,SBITS	!Sizes.
       INTEGER SORG	!Where the sieve starts. This must be three.
       INTEGER SLAST	!Last record in my stash file.
       DATA SSTASH,SREC,SLAST/0,0,0/	!Prepared by PRIMEBAG.
       PARAMETER (SRECLEN = 1024)	!4K disc bloc size, but RECL (in OPEN) is in terms of four-byte integers.
       PARAMETER (SCHARS = (SRECLEN - 1)*4)	!Reserving space for one number at the start.
       PARAMETER (SBITS = SCHARS*8)	!Known size of a character.
       PARAMETER (SORG = 3)		!First odd number past two, which is not odd.
       CHARACTER*(*) SFILE		!A name is needed.
       PARAMETER (SFILE = "C:/Nicky/RosettaCode/Primes/PrimeSieve.bit")	!I don't have to count the characters.
Components of a buffered record for the stash.
       INTEGER SREC	!The record number.
       CHARACTER*1 C4(4)	!The start of the record - a counter.
       CHARACTER*1 SCHAR(0:SCHARS - 1)	!The majority of the record - a bit array, packed in 8-bit blobs...
Collect some bit twiddling assistants for AND and OR, rather than bit shifting.
       CHARACTER*1 BITON(0:7),BITOFF(0:7)	!Functions IBSET and IBCLR may not be available, and are little-endian anyway.
       PARAMETER (BITON =(/CHAR(2#10000000),CHAR(2#01000000),	!128,  64,	Reading strictly left-to-right.
     1                     CHAR(2#00100000),CHAR(2#00010000),	! 32,  16,	Uncompromising bigendery.
     1                     CHAR(2#00001000),CHAR(2#00000100),	!  8,   4,	Not just for bytes in words,
     3                     CHAR(2#00000010),CHAR(2#00000001)/))	!  2,   1.	But also bits in bytes.
       PARAMETER (BITOFF=(/CHAR(2#01111111),CHAR(2#10111111),	!127, 191,	BITON + BITOFF = 255.
     2                     CHAR(2#11011111),CHAR(2#11101111),	!223, 239,
     1                     CHAR(2#11110111),CHAR(2#11111011),	!247, 251,
     3                     CHAR(2#11111101),CHAR(2#11111110)/))	!253, 254.
       CONTAINS
        INTEGER FUNCTION I4UNPACK(C4)	!Convert four successive characters into an integer.
         CHARACTER*1 C4(4)	!The characters.
          I4UNPACK = ((ICHAR(C4(1))*256 + ICHAR(C4(2)))*256	!Convert the first four bytes
     1               + ICHAR(C4(3)))*256 + ICHAR(C4(4))		!To a four-byte integer.
        END FUNCTION I4UNPACK	!Big-endian style, irrespective of cpu endianness.
        SUBROUTINE C4PACK(I4)	!Convert an integer into successive bytes.
Could return the result via a fancy function, but for now a global variable will do.
         INTEGER I4,N	!The integer, and a copy to damage.
         INTEGER I	!A stepper.
          N = I4	!Keep the original safe.
          DO I = 4,1,-1	!Know that four characters will do. Fixed format makes this easy.
            C4(I) = CHAR(MOD(N,256))	!Grab the low-order eight bits.
            N = N/256			!And shift right eight.
          END DO			!Do it again.
        END SUBROUTINE C4PACK	!Stored big-endianly, irrespective of cpu endianness.

        LOGICAL FUNCTION GRASPPRIMEBAG(F)
         INTEGER F		!The I/O unit number to use.
         LOGICAL EXIST		!Use the keyword as a name
         INTEGER IOSTAT		!And don't worry over assignment direction.
         CHARACTER*3 STYLE	!One way or another.
          SSTASH = F		!I shall use it.
          INQUIRE (FILE = SFILE,EXIST = EXIST)	!Trouble with a missing "path" may arise.
          IF (EXIST) THEN	!If the file exists,
            STYLE = "OLD"	!I shall read it.
           ELSE			!But if it doesn't,
            STYLE = "NEW"	!I shall create it.
          END IF		!Enough prevarication.
          OPEN(SSTASH,FILE = SFILE, STATUS = STYLE,	!Go for the file.
     &     ACCESS = "DIRECT", RECL = SRECLEN, FORM = "UNFORMATTED",	!I have plans.
     &     ERR = 666, IOSTAT = IOSTAT)					!Which may be thwarted.
          IF (EXIST) THEN	!If there is one...
            CALL READSCHAR(1)	!The first record is also a header.
            SLAST = I4UNPACK(C4)	!The number of records stored.
           ELSE			!Otherwise, start from scratch.
            SLAST = 0			!No saved records.
            CALL PSURGE(SCHAR)		!During preparation of the first batch of bits.
          END IF		!All should now be in readiness.
          GRASPPRIMEBAG = .TRUE.!So, feel confidence.
         RETURN			!And escape.
  666     WRITE (*,667) IOSTAT,SFILE	!But, something may have gone wrong.
  667     FORMAT ("Pox! Error code ",I0,	!A "hole" in the directory path?
     1     " when attempting to open file ",A)	!Read-only access allowed when I want "update"?
          GRASPPRIMEBAG = .FALSE.		!Whatever, it didn't work.
        END FUNCTION GRASPPRIMEBAG	!So much for that.

        SUBROUTINE READSCHAR(R)	!Get record R into SCHAR, which may already hold it.
         INTEGER R		!The record number desired.
          IF (R.EQ.SREC) RETURN	!Perhaps it is already to hand.
          SREC = R		!If not, move attention to it.
          READ (SSTASH,REC = SREC) C4,SCHAR	!And read the record.
        END SUBROUTINE READSCHAR!Thus, I have a buffer too.

        LOGICAL FUNCTION PSURGE(BIT8)	!Add another record to the stash.
C   Surges forward into the next batch of primes, to be stored via a bit array in the file.
C   Each record starts with a count of the number of primes that have gone before.
C   Except that for the first record, this is the record counter for the stash file.
C   Except that when starting the second record, one is also the number of primes before SORG.
         CHARACTER*1 BIT8(0:SCHARS - 1)	!Watch out! This may be SCHAR itself!
         INTEGER IST,LST	!The numbers spanned by the surge.
         INTEGER F		!A factor.
         INTEGER I		!Another factor and a stepper.
         INTEGER C		!Index for array BIT8.
         INTEGER NP		!Number of primes.
Carry forward the count of previous primes to start the following record..
   10     IF (SLAST.GT.0) THEN	!Is there a previous record?
            CALL READSCHAR(SLAST)	!Yes. Grab it. A good chance this is already in C4,SCHAR.
            NP = I4UNPACK(C4)		!Its count of the primes accumulated before it.
            DO I = 0,SCHARS - 1		!Find out how namy primes it fingered by scanning its bits.
              NP = NP + COUNT(IAND(ICHAR(SCHAR(I)),ICHAR(BITON)).NE.0)	!Whee! Eight at a go!
            END DO			!On to the next byte.
          END IF		!When creating a new record, its follower may not be sought in this run.
Concoct the next batch of bits. Contorted calculations avoid integer overflow.
   20     BIT8 = CHAR(255)		!All bits are aligned with numbers that might prove to be prime.
          IST = SORG + SLAST*(2*SBITS)	!Bit(0) of BIT8(0) corresponds to IST.
          LST = IST + 2*(SBITS - 1)	!Bit(last) to this number. Remember, only odd numbers have bits.
          IF (IST.LE.0) THEN		!Humm. I'd better check.
            WRITE (MSG,21) SLAST,IST,LST	!This works only with two's complement integers.
   21       FORMAT (/,"Integer overflow in the sieve of Eratosthenes!",	!Oh dear.
     1      /,"Advancing from surge ",I0," to span ",I0," to ",I0)	!These numbers will look odd.
            PSURGE = .FALSE.			!But it is better than no indication of what went wrong.
           RETURN			!Give in.
          END IF		!Enough worrying.
          F = 3			!The first possible factor. Zapping will start at F²
c         DO WHILE(F.LE.LST/F)	!If F² is past the end, so will be still larger F: enough.
          DO WHILE(F.LE.IST/F + (MOD(IST,F) + 2*(SBITS - 1))/F)	!"Synthetic division" avoiding overflow.
            I = (IST - 1)/F + 1		!I want the first multiple of F in IST:LST. F may be a factor of IST.
            IF (MOD(I,2).EQ.0) I = I + 1!If even, advance to the next odd multiple. Even numbers are omitted by design.
            IF (I.LT.F) I = F		!Less than F is superfluous: the position was zapped by earlier action.
c           I = (I*F - IST)/2			!Current bit positions are for IST, IST+2, IST+4, etc.
            I = ((I - IST/F)*F - MOD(IST,F))/2	!Avoids overflow when calculating the start value, I*F.
            DO I = I,SBITS - 1,F	!Zap every F'th bit along. This is the sieve of Eratosthenes.
              C = I/8				!Eight bits per character.
              BIT8(C) = CHAR(IAND(ICHAR(BIT8(C)),	!For F = 3 and 5, characters will be hit more than once.
     1                            ICHAR(BITOFF(MOD(I,8)))))	!Whack a bit. All the above just for this!
            END DO			!On to the next bit.
   22       F = NEXTPRIME(F)		!So much for F. Next, please.
          END DO		!Are we there yet?
Correct the count in the header, if this is an added record.
   30     IF (SLAST.GT.0) THEN	!So, was there a pre-existing header record?
            CALL READSCHAR(1)		!Yes. Get the header record into C4,SCHAR.
            CALL C4PACK(SLAST + 1)	!This is the new record count.
            WRITE (SSTASH,REC = 1) C4,SCHAR	!Write it all back.
            SCHAR = BIT8	!Ensure that SCHAR and SREC will be agreed.
          END IF		!So much for the header's count.
Cast the bits into the stash by writing record SLAST + 1..
   40     IF (SLAST.EQ.0) THEN	!If we're writing the first record,
            CALL C4PACK(1)		!Then this is the record count.
           ELSE			!Otherwise,
            CALL C4PACK(NP)		!Place the previous primes count.
          END IF		!All this to help PRIME(i).
          SLAST = SLAST + 1	!This is now the last stashed record.
          WRITE (SSTASH,REC = SLAST) C4,BIT8	!I/O directly from the work area?
          SREC = SLAST		!This is where BIT8 was written.
          PSURGE = .TRUE.	!That assumes BIT8 is not SCHAR for SLAST > 1.
        END FUNCTION PSURGE	!That was fun!

        RECURSIVE SUBROUTINE GETSREC(R)	!Make present the bit array belonging to record R.
         INTEGER R		!The record number..
         CHARACTER*1 BIT8(0:SCHARS - 1)	!A scratchpad. Others may be relying on SCHAR.
          IF (SLAST.LE.0) RETURN!DANGER! The first record is being initialised!
          DO WHILE(SLAST.LT.R)	!If we haven't reached so far,
            IF (.NOT.PSURGE(BIT8)) THEN	!Slog forwards one record's worth.
              WRITE (MSG,1) R			!Or maybe not.
    1         FORMAT ("Cannot prepare surge ",I0)	!Explain.
              STOP "No bits, no go."			!And quit.
            END IF			!And having prepared the next block of bits,
          END DO		!Check afresh.
          CALL READSCHAR(R)	!Read the desired record's bits.
        END SUBROUTINE GETSREC	!Done.

        INTEGER FUNCTION PRIME(N)	!P(1) = 2, P(2) = 3, etc.
C   Calculate P(n) ~ n.ln(n)
C                  ~ n{ln(n) + ln(ln(n)) - 1 + (ln(ln(n)) - 2)/ln(n) - [ln(ln(n))**2 - 6*log(log(n)) + 11]/[2*(ln(n))**2] + ....}
C   J.B.Rosser's 1938 Theorem: n[ln(n) + ln(ln(n)) - 1] < P(n) < n[ln(n) + ln(ln(n))]
C    or, with E = ln(n) + ln(ln(n)),           n[E - 1] < P(n) < n[E]
C   Experimentation shows that the undershoot of the first two terms involves many records worth of bits.
C   Including additional terms does much better, but can overshoot.
         INTEGER N		!The desired one.
         INTEGER R,NP		!Counts.
         INTEGER B,C		!Bit and character indices.
         DOUBLE PRECISION EST,LN,LLN	!Hope, if not actuality.
          IF (N.LE.0) STOP "Primes are counted positively!"	!Something must be wrong!
          IF (N.LE.1) THEN	!The start of the bit array being preempted.
            PRIME = 2			!So, no array access.
           ELSE			!Otherwise, the fun begins.
            LN = LOG(DFLOAT(N))	!Here we go.
            LLN = LOG(LN)	!A popular term.
            EST = N*(LN		!Estimate the value of the N'th prime.
     1               + LLN - 1		!Second term
     2               + (LLN - 2)/LN		!Third term.
     3               - (LLN**2 - 6*LLN + 11)/(2*LN**2))	!Fourth term.
            R = (EST - SORG)/(2*SBITS) + 1	!Thereby selecting a record to scan.
            IF (R.LE.0) R = 1			!And not making a mess with N < 6 or so.
    9       CALL GETSREC(R)	!Go for the record.
            IF (R.LE.1) THEN	!The first record starts with the record count.
              NP = 1		!And I know how many primes precede its start point
             ELSE		!While for all subsequent records,
              NP = I4UNPACK(C4)	!This counts the number of primes that precede record R's start number.
            END IF		!So now I'm ready to count onwards.
            IF (N.LE.NP) THEN	!Maybe not.
              R = R - 1			!The estimate took me too far ahead.
              GO TO 9			!Try again.
            END IF		!Could escalate to a binary search or even an interpolating search.
Commence scanning the bits.
            C = 0		!Start with the first character of SREC..
            B = -1		!Syncopation. The formula is known to always under-estimate.
   10       IF (NP.LT.N) THEN	!Are we there yet?
   11         B = B + 1			!No. Advance to the next bit.
              IF (B.GE.8) THEN		!Overflowed a character yet?
                B = 0			!Yes. Start afresh at the first bit.
                C = C + 1		!And advance one character.
                IF (C.GE.SCHARS) THEN	!Overflowed the record yet?
                  C = 0			!Yes. Start afresh at its first character.
                  R = R + 1		!And advance to the next record.
                  CALL GETSREC(R)	!Possibly, create it.
                END IF			!So much for records.
              END IF			!We're now ready to test bit B of character C of record R.
              IF (IAND(ICHAR(SCHAR(C)),ICHAR(BITON(B))).EQ.0) GO TO 11	!Not a prime. Search on.
              NP = NP + 1		!Count another prime.
              GO TO 10			!Pehaps this will be the one.
            END IF		!So much for the search.
            PRIME = SORG + (R - 1)*(2*SBITS) + (C*8 + B)*2	!The corresponding number.
            IF (PRIME.LE.0) WRITE (MSG,666) N,PRIME	!Or, possibly not.
  666       FORMAT ("Integer overflow! Prime(",I0,") gives ",I0,"!")	!Let us hope the caller notices.
          END IF		!So, all going well,
        END FUNCTION PRIME	!It is found.

        RECURSIVE INTEGER FUNCTION NEXTPRIME(N)	!Keep right on to the end of the road.
Can invoke GETSREC, which can invoke PSURGE, which ... invokes NEXTPRIME. Oh dear.
         INTEGER N	!Not necessarily itself a prime number.
         INTEGER NN	!A value to work with.
         INTEGER R	!A record number into the stash.
         INTEGER I,IST	!Number offsets.
         INTEGER C,B	!Character and bit index.
          IF (N.LE.1) THEN	!Suspicion prevails.
            NN = 2			!This is not represented in my bit array.
           ELSE			!Otherwise, the fun begins.
            NN = N + 1			!Advance, with a copy I can mess with.
            IF (MOD(NN,2).EQ.0) NN = NN + 1	!Thus, NN is now odd.
            IF (NN.LE.0) GO TO 666		!But perhaps not proper, due to overflow.
            R = (NN - SORG)/(2*SBITS)		!SORG is odd, so (NN - SORG) is even.
            CALL GETSREC(R + 1)		!The first record is numbered one, not zero.
            IST = SORG + R*(2*SBITS)	!The number for its first bit: even numbers are omitted..
            I = (NN - IST)/2		!Offset into the record. NN - IST is even.
            C = I/8			!Which character in SCHAR(0:SCHARS - 1)?
            B = MOD(I,8)		!Which bit in SCHAR(C)?
   10       IF (IAND(ICHAR(SCHAR(C)),ICHAR(BITON(B))).EQ.0) THEN	!On for a prime.
              NN = NN + 2	!Alas, it is off, so NN is not a prime. Perhaps this will be.
              B = B + 1		!Advance one bit. Each bit steps two.
              IF (B.GE.8) THEN	!Past the end of the character?
                B = 0			!Yes. Back to bit zero.
                C = C + 1		!And advance one chracter.
                IF (C.GE.SCHARS) THEN	!Past the end of the record?
                  IF (NN.LE.0) GO TO 666!Yes. If NN has overflowed, the end of the rope is reached.
                  C = 0			!Back to the start of a record.
                  R = R + 1		!Advance one record.
                  CALL GETSREC(R + 1)	!And read it. (Count is from 1, not 0).
                END IF		!So much for overflowing a record.
              END IF		!So much for overflowing a character.
              GO TO 10	!Try again.
            END IF		!So much for the bit array.
          END IF		!If there had been a scan.
          NEXTPRIME = NN	!The number for which the scan stopped.
          IF (NN.GT.0) RETURN	!All is well.
  666     WRITE (MSG,667) N,NN	!Or, maybe not. Careful: this won't appear if NEXTPRIME is invoked in a WRITE list.
  667     FORMAT ("Integer overflow! NextPrime(",I0,") gives ",I0,"!")	!The recipient could do a two's complement.
          NEXTPRIME = NN	!Prefer to return the bad value rather than fail to return anything.
        END FUNCTION NEXTPRIME	!No divisions, no sieving. Here, anyway

        INTEGER FUNCTION PREVIOUSPRIME(N)	!If N is good, this can't overflow.
         INTEGER N	!The number, not necessarily a prime.
         INTEGER NN	!A value to mess with.
         INTEGER R	!A record number.
         INTEGER I	!Offset.
         INTEGER C,B	!Character and bit fingers.
          IF (N.LE.3) THEN	!Suppress annoyances.
            NN = 2		!This is now called the first prime, not one.
           ELSE			!Otherwise, some work is to be done.
            NN = N - 1			!Step back one to ensure previousness.
            IF (MOD(NN,2).EQ.0) NN = NN - 1	!And here, oddness is a minimal requirement.
            R = (NN - SORG)/(2*SBITS)	!Finger the record containing the bit for NN.
            CALL GETSREC(R + 1)		!Record counting starts with one.
            I = (NN - (SORG + R*(2*SBITS)))/2	!Offset into that record.
            C = I/8			!Finger the character in SCHAR.
            B = MOD(I,8)		!And the bit within the character.
   10       IF (IAND(ICHAR(SCHAR(C)),ICHAR(BITON(B))).EQ.0) THEN	!On for a prime.
              NN = NN - 2	!Alas, it is off, so NN is not a prime. Perhaps this will be.
              B = B - 1		!Retreat one bit. Each bit steps two.
              IF (B.LT.0) THEN	!Past the start of the character?
                B = 7			!Yes. Back to the last bit.
                C = C - 1		!And retreat one chracter.
                IF (C.LT.0) THEN	!Past the start of the record?
                  C = SCHARS - 1	!Yes. Back to the end of a record.
                  R = R - 1		!Retreat one record.
                  CALL GETSREC(R + 1)	!And read it. (Count is from 1, not 0).
                END IF		!So much for overflowing a record.
              END IF		!So much for overflowing a character.
              GO TO 10		!Try again.
            END IF		!So much for the bit array.
          END IF		!Possibly, it was not needed.
          PREVIOUSPRIME = NN	!There.
        END FUNCTION PREVIOUSPRIME	!Doesn't overflow, either.

        LOGICAL FUNCTION ISPRIME(N)	!Could fool around explicity testing 2 and 3 and say 5,
         INTEGER N			!But that means also checking that N > 2, N > 3, and N > 5.
c        ISPRIME = N .EQ. NEXTPRIME(N - 1)	!This is so much easier, but involves scanning to reach the next prime.
         INTEGER R,IST,I,C,B		!Assistants for indexing the bit array.
          IF (N.LE.1) THEN	!First, preclude sillyness.
            ISPRIME = .FALSE.		!Not a prime.
          ELSE IF (N.EQ.2) THEN	!This is the only even number
            ISPRIME = .TRUE.		!That is a prime.
          ELSE IF (MOD(N,2).EQ.0) THEN	!Other even numbers
            ISPRIME = .FALSE.		!Are not prime numbers.
          ELSE			!Righto, now N is an odd number and there is a bit array for them.
            R = (N - SORG)/(2*SBITS)	!SORG is odd, so (N - SORG) is even.
            CALL GETSREC(R + 1)		!The first record is numbered one, not zero.
            IST = SORG + R*(2*SBITS)	!The number for its first bit: even numbers are omitted.
            I = (N - IST)/2		!Offset into the record. N - IST is even.
            C = I/8			!Which character in SCHAR(0:SCHARS - 1)?
            B = MOD(I,8)		!Which bit in SCHAR(C), indexing from zero?
            ISPRIME = IAND(ICHAR(SCHAR(C)),ICHAR(BITON(B))).GT.0	!The bit is on for a prime.
          END IF			!All that fuss to find a single bit.
        END FUNCTION ISPRIME		!But, no divisions up to SQRT(N) or the like.
      END MODULE PRIMEBAG	!Functions updating a disc file as a side effect...

      PROGRAM POKE
      USE PRIMEBAG
      INTEGER I,P,N,N1,N2	!Assorted assistants.
      INTEGER ORDER		!A collection of special values.
      PARAMETER (ORDER = 6)	!For one, two, and four byte integers.
      INTEGER EDGE(ORDER)	!Considered as two's complement and unsigned.
      PARAMETER (EDGE = (/31,54,3512,6542,105097565,203280221/))	!These primes are of interest.
      MSG = 6		!Standard output.

      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file!"	!Attempt in hope.

Case 1.
C     FORALL(I = 1:20) LIST(I) = PRIME(I) is rejected because function Prime(i) is rather impure.
   10 WRITE (MSG,11)
   11 FORMAT (19X,"First twenty primes: ", $)
      DO I = 1,20
        P = PRIME(I)
        WRITE (MSG,12) P
   12   FORMAT (I0,",",$)
      END DO

Case 2.
   20 WRITE (MSG,21)
   21 FORMAT (/,12X,"Primes between 100 and 150: ",$)
      P = 100
   22 P = NEXTPRIME(P)		!While (P:=NextPrime(P)) <= 150 do Print P;
      IF (P.LE.150) THEN	!But alas, no assignment within an expression.
        WRITE (MSG,23) P
   23   FORMAT (I0,",",$)
        GO TO 22
      END IF

Case 3.
   30 N1 = 7700	!Might as well parameterise this.
      N2 = 8000	!Rather than litter the source with explicit integers.
      N = 0
      P = N1
   31 P = NEXTPRIME(P)
      IF (P.LE.N2) THEN
        N = N + 1
        GO TO 31
      END IF
      WRITE (MSG,32) N1,N2,N
   32 FORMAT (/"Number of primes between ",I0," and ",I0,": ",I0)

Case 4.
   40 WRITE (MSG,41)
   41 FORMAT (/,"Tenfold steps...")
      N = 1
      DO I = 1,9	!This goes about as far as it can go.
        P = PRIME(N)
        WRITE (MSG,42) N,P
   42   FORMAT ("Prime(",I0,") = ",I0)
        N = N*10
      END DO

Cast forth some interesting values.
  100 WRITE (MSG,101)
  101 FORMAT (/,"Primes close to number sizes")
      DO N = 1,ORDER	!Step through the list.
        N1 = EDGE(N) - 1	!Syncopation for the special value.
        DO I = 1,2		!I want the prime on either side.
          N1 = N1 + 1			!So, there are two successive primes to finger.
          WRITE (MSG,102) N1			!Identify the index.
  102     FORMAT ("Prime(",I0,") = ",$)		!Piecemeal writing to the output,
          P = PRIME(N1)				!As this may fling forth a complaint.
          WRITE (MSG,103) P			!Show the value returned.
  103     FORMAT (I0,", ",$)			!Which may be unexpected.
        END DO			!On to the second.
        WRITE (MSG,*)		!End the line after the second result.
      END DO		!On to the next in the list.

      END	!Whee!
