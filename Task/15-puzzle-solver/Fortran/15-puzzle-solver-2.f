      SUBROUTINE PROUST(T)	!Remembrance of time passed.
       DOUBLE PRECISION T	!The time, in seconds. Positive only, please.
       DOUBLE PRECISION S	!A copy I can mess with.
       TYPE TIMEWARP		!Now prepare a whole lot of trickery for expressing the wait time.
        INTEGER LIMIT		!The upper limit for the usage.
        INTEGER STEP		!Conversion to the next unit.
        CHARACTER*4 NAME	!A suitable abbreviated name for the accepted unit.
       END TYPE TIMEWARP	!Enough of this.
       INTEGER CLOCKCRACK	!How many different units might I play with?
       PARAMETER (CLOCKCRACK = 5)	!This should so.
       TYPE(TIMEWARP) TIME(CLOCKCRACK)	!One set, please.
       PARAMETER (TIME = (/		!The mention of times lost has multiple registers.
     1  TIMEWARP(99, 60,"secs"),	!Beware 99.5+ rounding up to 100.
     2  TIMEWARP(99, 60,"mins"),	!Likewise with minutes.
     3  TIMEWARP(66, 24,"hrs!"),	!More than a few days might as well be in days.
     4  TIMEWARP(99,365,"days"),	!Too many days, and we will speak of years.
     5  TIMEWARP(99,100,"yrs!")/))	!And the last gasp converts to centuries.
       INTEGER CC		!A stepper for these selections.
       CHARACTER*4 U		!The selected unit.
       INTEGER MSG		!The mouthpiece.
       COMMON/IODEV/ MSG	!Used in common.
        S = T			!A working copy.
        DO CC = 1,CLOCKCRACK	!Now re-assess DT, with a view to announcing a small number.
          IF (S.LE.TIME(CC).LIMIT) THEN	!Too big a number?
            U = TIME(CC).NAME			!No, this unit will suffice.
            GO TO 10				!Make off to use it.
          END IF			!But if the number is too big,
          S = S/TIME(CC).STEP		!Escalate to the next larger unit.
        END DO 			!And see if that will suffice.
        U = "Cys!!"		!In case there are too many years, this is the last gasp.
   10   WRITE (MSG,11) S,U	!Say it.
   11   FORMAT (F7.1,A4,$)	!But don't finish the line.
       END SUBROUTINE PROUST	!A sigh.

       CHARACTER*15 FUNCTION HMS(T)	!Report the time of day.
Careful! Finite precision and binary/decimal/sexagesimal conversion could cause 2:30:00am. to appear as 2:29:60am.
        DOUBLE PRECISION S,T	!Seconds (completed) into the day.
        INTEGER H,M		!More traditional units are to be extracted.
        INTEGER SECONDSINDAY	!A canonical day.
        PARAMETER (SECONDSINDAY = 24*60*60)	!Of nominal seconds.
        CHARACTER*15 TEXT	!A scratchpad.
         H = T			!Truncate into an integer.
         S = T - (H - 1)/SECONDSINDAY*SECONDSINDAY	!Thus allow for midnight = hour 24.
         IF (S.EQ.SECONDSINDAY/2) THEN	!This might happen.
           TEXT = "High Noon!"	!Though the chances are thin.
         ELSE IF (S.EQ.SECONDSINDAY) THEN	!This is synonymous with the start of the next day.
           TEXT = "Midnight!"	!So this presumably won't happen.
         ELSE		!But more likely are miscellaneous values.
           H = S/3600		!Convert seconds into whole hours completed.
           S = S - H*3600	!The remaining time.
           M = S/60		!Seconds into minutes completed.
           S = S - M*60		!Remove them.
           IF (S .GE. 59.9995D0) THEN	!Via format F6.3, will this round up to 60?
             S = 0		!Yes. Curse recurring binary sequences for decimal.
             M = M + 1		!So, up the minute count.
             IF (M.GE.60) THEN	!Is there an overflow here too?
               M = 0		!Yes.
               H = H + 1	!So might appear 24:00:00.000 though it not be Midnight!
             END IF		!So much for twiddling the minutes.
           END IF		!And twiddling the hours.
           IF (H.LT.12) THEN	!A plague on the machine mentality.
             WRITE (TEXT,1) H,M,S,"am."	!Ante-meridian.
    1        FORMAT (I2,":",I2,":",F6.3,A3)	!Thus.
            ELSE		!For the post-meridian, H >= 12.
             IF (H.GT.12) H = H - 12	!Adjust to civil usage. NB! 12 appears.
             WRITE (TEXT,1) H,M,S,"pm."	!Thus. Post-meridian.
           END IF	!So much for those fiddles.
           IF (TEXT(4:4).EQ." ") TEXT(4:4) = "0"	!Now help hint that the
           IF (TEXT(7:7).EQ." ") TEXT(7:7) = "0"	! character string is one entity.
         END IF		!So much for preparation.
         HMS = TEXT	!The result.
       END FUNCTION HMS	!Possible compiler confusion if HMS is invoked in a WRITE statement.

       DOUBLE PRECISION FUNCTION NOWWAS(WOT)	!Ascertain the local time for interval assessment.
Compute with whole day numbers, to avoid day rollover annoyances.
Can't use single precision and expect much discrimination within a day.
C I'd prefer a TIMESTAMP(Local) and a TIMESTAMP(GMT) system function.
C Quite likely, the system separates its data to deliver the parameters, which I then re-glue.
        INTEGER WOT	!What sort of time do I want?
        REAL*8 TIME	!A real good time.
        INTEGER MARK(8)	!The computer's clock time will appear here, but fragmented.
         IF (WOT.LE.0) THEN	!Just the CPU time for this.
           CALL CPU_TIME(TIME)	!Apparently in seconds since starting.
          ELSE			!But normally, I want a time-of-day now.
           CALL DATE_AND_TIME(VALUES = MARK)	!Unpack info that I will repack.
c           WRITE (6,1) MARK
c    1      FORMAT ("The computer clock system reports:",
c     1      /"Year",I5,", Month",I3,", Day",I3,
c     2      /" Minutes from GMT",I5,
c     3      /" Hour",I3,", Minute",I3,",Seconds",I3,".",I3)
           TIME = (MARK(5)*60 + MARK(6))*60 + MARK(7) + MARK(8)/1000D0	!By the millisecond, to seconds.
           IF (WOT.GT.1) TIME = TIME - MARK(4)*60	!Shift back to GMT, which may cross a day boundary.
c          TIME = DAYNUM(MARK(1),MARK(2),MARK(3)) + TIME/SECONDSINDAY	!The fraction of a day is always less than 1 as MARK(5) is declared < 24.
           TIME = MARK(3)*24*60*60 + TIME	!Not bothering with DAYNUM, and converting to use seconds rather than days as the unit.
         END IF			!A simple number, but, multiple trickeries. The GMT shift includes daylight saving's shift...
         NOWWAS = TIME		!Thus is the finger of time found.
       END FUNCTION NOWWAS	!But the Hand of Time has already moved on.

      MODULE SLIDESOLVE		!Collect the details for messing with the game board.
       INTEGER NR,NC,N				!Give names to some sizes.
       PARAMETER (NR = 4, NC = 4, N = NR*NC)	!The shape of the board.
       INTEGER*1 BOARD(N),TARGET(N),ZERO(N)	!Some scratchpads.
       INTEGER BORED(4)				!A re-interpretation of the storage containing the BOARD.
       CHARACTER*(N) BOAR			!Another, since the INDEX function only accepts these.
       EQUIVALENCE (BORED,BOARD,BOAR)		!All together now!
       CHARACTER*1 DIGIT(0:35)			!This will help to translate numbers to characters.
       PARAMETER (DIGIT = (/"0","1","2","3","4","5","6","7","8","9",
     1  "A","B","C","D","E","F","G","H","I","J",	!I don't anticipate going beyond 15.
     2  "K","L","M","N","O","P","Q","R","S","T",	!But, for completeness...
     3  "U","V","W","X","Y","Z"/))			!Add a few more.
      CONTAINS
       SUBROUTINE SHOW(NR,NC,BOARD)	!The layout won't work for NC > 99...
        INTEGER NR,NC		!Number of rows and columns.
        INTEGER*1 BOARD(NC,NR)	!The board is stored transposed, in Furrytran!
        INTEGER R,C		!Steppers.
        INTEGER MSG		!Keep the compiler quiet.
        COMMON/IODEV/ MSG	!I talk to the trees...
         WRITE (MSG,1) (C,C = 1,NC)	!Prepare a heading.
    1    FORMAT ("Row|",9("__",I1,:),90("_",I2,:))	!This should suffice.
         DO R = 1,NR		!Chug down the rows, for each showing a succession of columns.
           WRITE (MSG,2) R,BOARD(1:NC,R)	!Thus, successive elements of storage. Storage style is BOARD(column,row).
    2      FORMAT (I3,"|",99I3)		!Could use parameters, but enough.
         END DO			!Show columns across and rows down, despite the storage order.
       END SUBROUTINE SHOW	!Remember to transpose the array an odd number of times.

       SUBROUTINE UNCRAM(IT,BOARD)	!Recover the board layout..
        INTEGER IT(2)		!Two 32-bit integers hold 16 four-bit fields in a peculiar order.
        INTEGER*1 BOARD(*)	!This is just a simple, orderly sequence of integers.
        INTEGER I,HIT		!Assistants.
         DO I = 0,8,8		!Unpack into the work BOARD.
           HIT = IT(I/8 + 1)		!Grab eight positions, in four bits each..
                                BOARD(I + 5) = IAND(HIT,15)	!The first is position 5.
           HIT = ISHFT(HIT,-4); BOARD(I + 1) = IAND(HIT,15)	!Hex 48372615
           HIT = ISHFT(HIT,-4); BOARD(I + 6) = IAND(HIT,15)	!and C0BFAE9D
           HIT = ISHFT(HIT,-4); BOARD(I + 2) = IAND(HIT,15)	!For BOARD(1) = 1, BOARD(2) = 2,...
           HIT = ISHFT(HIT,-4); BOARD(I + 7) = IAND(HIT,15)	!This computer is (sigh) little-endian.
           HIT = ISHFT(HIT,-4); BOARD(I + 3) = IAND(HIT,15)	!Rather than mess with more loops,
           HIT = ISHFT(HIT,-4); BOARD(I + 8) = IAND(HIT,15)	!Explicit code is less of a brain strain.
           HIT = ISHFT(HIT,-4); BOARD(I + 4) = IAND(HIT,15)	!And it should run swiftly, too...
         END DO				!Only two of them.
       END SUBROUTINE UNCRAM	!A different-sized board would be a problem too.

       INTEGER*8 FUNCTION ZDIST(BOARD)	!Encode the board's positions against the ZERO sequence.
        INTEGER*1 BOARD(N)	!The values of the squares.
        LOGICAL*1 AVAIL(N)	!The numbers will be used one-by-one to produce ZC.
        INTEGER BASE		!This is not a constant, such as ten.
        INTEGER M,IT		!Assistants.
         AVAIL = .TRUE.			!All numbers are available.
         BASE = N			!The first square has all choices.
         ZDIST = 0			!Start the encodement of choices.
         DO M = 1,N			!Step through the board's squares.
           IT = BOARD(M)			!Grab the square's number. It is the index into ZERO.
           IF (IT.EQ.0) IT = N			!But in ZERO, the zero is at the end, damnit.
           AVAIL(IT) = .FALSE.			!This number is now used.
           ZDIST = ZDIST*BASE + COUNT(AVAIL(1:IT - 1))	!The number of available values to skip to reach it.
           BASE = BASE - 1			!Option count for the next time around.
         END DO				!On to the next square.
       END FUNCTION ZDIST	!ZDIST(ZERO) = 0.

       SUBROUTINE REPORT(R,WHICH,MOVE,BRD)	!Since this is invoked in two places.
        INTEGER R		!The record number of the position.
        CHARACTER*(*) WHICH	!In which stash.
        CHARACTER*1 MOVE	!The move code.
        INTEGER BRD(2)		!The crammed board position.
        INTEGER*1 BOARD(N)	!Uncrammed for nicer presentation.
        INTEGER*8 ZC		!Encodes the position in a mixed base.
        INTEGER ZM,ZS		!Alternate forms of distance.
        DOUBLE PRECISION ZE	!This is Euclidean.
        INTEGER MSG		!Being polite about usage,
        COMMON/IODEV/MSG	!Rather than mysterious constants.
         CALL UNCRAM(BRD,BOARD)		!Isolate the details.
         ZM = MAXVAL(ABS(BOARD - ZERO))			!A norm. |(x,y)| = r gives a square shape.
         ZS = SUM(ABS(BOARD - ZERO))			!A norm. |(x,y)| = r gives a diamond shape.
         ZE = SQRT(DFLOAT(SUM((BOARD - ZERO)**2)))	!A norm. |(x,y)| = r gives a circle.
         ZC = ZDIST(BOARD)				!Encodement against ZERO.
         WRITE (MSG,1) R,WHICH,MOVE,DIGIT(BOARD),ZM,ZS,ZE,ZC	!After all that,
    1    FORMAT (I11,A6,A5,1X,"|",<NR - 1>(<NC>A1,"/"),<NC>A1,"|",	!Show the move and the board
     1    2I8,F12.3,I18)					!Plus four assorted distances.
       END SUBROUTINE REPORT	!Just one line is produced.

       SUBROUTINE PURPLE HAZE(BNAME)	!Spreads a red and a blue tide.
        CHARACTER*(*) BNAME		!Base name for the work files.
        CHARACTER*(N) BRAND		!Name part based on the board sequence.
        CHARACTER*(LEN(BNAME) + 1 + N + 4) FNAME	!The full name.
Collect the details for messing with the game board.
        CHARACTER*4 TIDE(2)			!Two tides will spread forth.
        PARAMETER (TIDE = (/" Red","Blue"/))	!With these names.
        INTEGER LZ,LOCZ(2),LOCI(2),ZR,ZC	!Location via row and column.
        EQUIVALENCE(LOCZ(1),ZR),(LOCZ(2),ZC)	!Sometimes separate, sometimes together.
        INTEGER WAY(4),HENCE,W,M,D,WAYS(2,4)	!Direction codes.
        PARAMETER (WAY = (/   +1,  -NC,   -1,  +NC/))	!Directions for the zero square, in one dimension.
        PARAMETER (WAYS = (/0,+1, -1,0, 0,-1, +1,0/))	!The same, but in (row,column) style.
        CHARACTER*1 WNAMEZ(0:4),WNAMEF(0:4)	!Names for the directions.
        PARAMETER (WNAMEZ = (/" ","R","U","L","D"/))	!The zero square's WAYS.
        PARAMETER (WNAMEF = (/" ","L","D","R","U"/))	!The moved square's ways are opposite.
Create two hashed stashes. A stash file and its index file, twice over.
        INTEGER APRIME				!Determines the size of the index.
        PARAMETER (APRIME = 199 999 991)	!Prime 11078917. Prime 6666666 = 116 743 349. Perhaps 1999999973?
        INTEGER HCOUNT(2),NINDEX(2)		!Counts the entries in the stashes and their indices.
        INTEGER P,HIT				!Fingers to entries in the stash.
        INTEGER SLOSH,HNEXT			!Advances from one surge to the next.
        INTEGER IST(2),LST(2),SURGE(2)		!Define the perimeter of a surge.
        INTEGER HEAD,LOOK			!For chasing along a linked-list of records.
        TYPE AREC				!Stores the board position, and helpful stuff.
         INTEGER NEXT					!Links to the next entry that has the same hash value.
         INTEGER PREV					!The entry from which this position was reached.
         INTEGER MOVE					!By moving the zero in this WAY.
         INTEGER BRD(2)					!Squeezed representation of the board position.
        END TYPE AREC				!Greater compaction (especially of MOVE) would require extra crunching.
        INTEGER LREC				!Record length, in INTEGER-size units. I do some counting.
        PARAMETER (LREC = 5)			!For the OPEN statement.
        TYPE(AREC) ASTASH,APROBE		!I need two scratchpads.
        INTEGER NCHECK				!Number of new positions considered.
        INTEGER NLOOK(2),PROBES(2),NP(2),MAXP(2)!Statistics for the primary and secondary searches resulting.
        LOGICAL SURGED(2)			!A SLOSH might not result in a SURGE.
Catch   the red/blue meetings, if any.
        INTEGER MANY,LONG			!They may be many, and, long.
        PARAMETER (MANY = 666,LONG = 66)	!This should do.
        INTEGER NMET,MET(2,MANY)		!Identify the meeting positions, in their own stash.
        INTEGER NTRAIL,TRAIL(LONG)		!Needed to follow the moves.
        INTEGER NS,LS(MANY)			!Count the shove sequences.
        CHARACTER*128 SHOVE(MANY)		!Record them.
Conglomeration of support stuff.
        LOGICAL EXIST				!For testing the presence of a disc file.
        INTEGER I,IT				!Assistants.
        DOUBLE PRECISION T1,T2,E1,E2,NOWWAS	!Time details.
        CHARACTER*15 HMS			!A clock.
        INTEGER MSG,KBD,WRK(2),NDX(2)	!I/O unit numbers.
        COMMON/IODEV/ MSG,KBD,WRK,NDX	!I talk to the trees...
         NS = 0	!No shove sequences have been found.
Concoct some disc files for storage areas, reserving the first record of each as a header.
   10    BOARD = ZERO	!The red tide spreads from "zero".
         DO W = 1,2	!Two work files are required.
           WRITE(MSG,11) TIDE(W)	!Which one this time?
   11      FORMAT (/,"Tide ",A)		!Might as well supply a name.
           DO I = 1,N		!Produce a text sequence for the board layout.
             BRAND(I:I) = DIGIT(BOARD(I))	!One by one...
           END DO		!BRAND = DIGIT(BOARD)
           FNAME = BNAME//"."//BRAND//".dat"	!It contains binary stuff, so what else but data?
           INQUIRE (FILE = FNAME, EXIST = EXIST)	!Perhaps it is lying about.
   20      IF (EXIST) THEN				!Well?
             WRITE (MSG,*) "Restarting from file ",FNAME	!One hopes its content is good.
             OPEN (WRK(W),FILE = FNAME,STATUS = "OLD",ACCESS = "DIRECT",	!Random access is intended.
     1        FORM = "UNFORMATTED",BUFFERED = "YES",RECL = LREC)		!Using record numbers as the key.
             FNAME = BNAME//"."//BRAND//".ndx"		!Now go for the accomplice.
             INQUIRE (FILE = FNAME, EXIST = EXIST)	!That contains the index.
             IF (.NOT.EXIST) THEN			!Well?
               WRITE (MSG,*) " ... except, no file ",FNAME	!Oh dear.
               CLOSE(WRK(W))				!So, no index for the work file. Abandon it.
               GO TO 20					!And thus jump into the ELSE clause below.
             END IF				!Seeing as an explicit GO TO would be regarded as improper...
             READ (WRK(W),REC = 1) HCOUNT(W),SURGE(W),IST(W),LST(W)!Get the header information.
             WRITE (MSG,22) HCOUNT(W),SURGE(W),IST(W),LST(W)	!Reveal.
   22        FORMAT (" Stashed ",I0,". At surge ",I0,		!Perhaps it will be corrupt.
     1        " with the boundary stashed in elements ",I0," to ",I0)	!If so, this might help the reader.
             OPEN (NDX(W),FILE = FNAME,STATUS = "OLD",ACCESS="DIRECT",	!Now for the accomplice.
     1        FORM = "UNFORMATTED",BUFFERED = "YES",RECL = 1)		!One INTEGER per record.
             READ(NDX(W), REC = 1) NINDEX(W)			!This count is maintained, to avoid a mass scan.
             WRITE (MSG,23) NINDEX(W),APRIME			!Exhibit the count.
   23        FORMAT (" Its index uses ",I0," of ",I0," entries.")	!Simple enough.
            ELSE			!But, if there is no stash, create a new one.
             WRITE (MSG,*) "Preparing a stash in file ",FNAME	!Start from scratch.
             OPEN (WRK(W),FILE = FNAME,STATUS="REPLACE",ACCESS="DIRECT",	!I intend non-sequential access...
     1        FORM = "UNFORMATTED",BUFFERED = "YES",RECL = LREC)		!And, not text.
             HCOUNT(W) = 1		!Just one position is known, the final position.
             SURGE(W) = 0		!It has not been clambered away from.
             IST(W) = 1			!The first to inspect at the current level.
             LST(W) = 1			!The last.
             WRITE (WRK(W),REC = 1) HCOUNT(W),SURGE(W),IST(W),LST(W),0	!The header.
             FNAME = BNAME//"."//BRAND//".ndx"	!Now for the associated index file..
             WRITE (MSG,*) "... with an index in file ",FNAME	!Announce before attempting access.
             OPEN (NDX(W),FILE = FNAME,STATUS = "REPLACE",ACCESS=	!Lest there be a mishap.
     1        "DIRECT",FORM = "UNFORMATTED",BUFFERED = "YES",RECL = 1)	!Yep. Just one value per record.
             WRITE (MSG,*) APRIME," zero values for an empty index."	!This may cause a pause.
             NINDEX(W) = 1				!The index will start off holding one used entry.
             WRITE (NDX(W),REC = 1) NINDEX(W)	!Save this count in the header record.
             WRITE (NDX(W),REC = 1 + APRIME) 0	!Zero values will also appear in the gap!
             ASTASH.NEXT = 0		!The first index emtry can never collide with another in an empty index.
             ASTASH.PREV = 0		!And it is created sufficient unto itself.
             ASTASH.MOVE = 0		!Thus, it is not a descendant, but immaculate.
             ASTASH.BRD(1) = BORED(1)*16 + BORED(2)	!Only four bits of the eight supplied are used.
             ASTASH.BRD(2) = BORED(3)*16 + BORED(4)	!So interleave them, pairwise.
             SLOSH = ASTASH.BRD(1)*ASTASH.BRD(2)	!Mash the bits together.
             HIT = ABS(MOD(SLOSH,APRIME)) + 2		!Make a hash. Add one since MOD starts with zero.
             WRITE (NDX(W),REC = HIT) HCOUNT(W)		!Adding another one to dodge the header as well.
             WRITE (MSG,24) BOARD,BORED,ASTASH.BRD,	!Reveal the stages.
     1        SLOSH,SLOSH,SLOSH,APRIME,HIT				!Of the mostly in-place reinterpretations.
   24        FORMAT (<N>Z2," is the board layout in INTEGER*1",/,	!Across the columns and down the rows.
     1        4Z8," is the board layout in INTEGER*4",/,		!Reinterpret as four integers.
     2        2(8X,Z8)," ..interleaved into two INTEGER*4",/,		!Action: Interleaved into two.
     3        Z32," multiplied together in INTEGER*4",/,		!Action: Their product.
     4        I32," as a decimal integer.",/,				!Abandoning hexadecimal.
     5        "ABS(MOD(",I0,",",I0,")) + 2 = ",I0,			!The final step.
     6        " is the record number for the first index entry.")	!The result.
             WRITE (WRK(W),REC = HCOUNT(W) + 1) ASTASH	!Record one is reserved as a header...
           END IF				!Either way, a workfile should be ready now.
           IF (W.EQ.1) BOARD = TARGET	!Thus go for the other work file.
         END DO		!Only two iterations, but a lot of blather.
         SLOSH = MINVAL(SURGE,DIM = 1)	!Find the laggard.

Cast forth a heading for the progress table to follow..
         WRITE (MSG,99)
   99    FORMAT (/,7X,"|",3X,"Tidewrack Boundary Positions  |",
     1    6X,"Positions",5X,"|",7X,"Primary Probes",9X,"Index Use",
     2    4X,"|",5X,"Secondary Probes",3X,"|"," Memory of Time Passed",/,
     3    "Surge",2X,"|",6X,"First",7X,"Last",6X,"Count|",
     4    4X,"Checked Deja vu%|",7X,"Made Max.L  Avg.L|   Used%",
     5    5X,"Load%|",7X,"Made Max.L  Avg.L|",6X,"CPU",8X,"Clock")

Chase along the boundaries of the red and the blue tides, each taking turns as primary and secondary interests.
  100    SLOSH = SLOSH + 1	!Another advance begins.
      WW:DO W = 1,2	!The advance is made in two waves, each with its own statistics.
           M = 3 - W		!Finger the other one.
           NMET = 0		!No meetings have happened yet.
           IF (SURGE(W).GE.SLOSH) CYCLE WW	!Prefer to proceed with matched surges.
           WRITE (MSG,101) SLOSH,TIDE(W),IST(W),LST(W),LST(W)-IST(W)+1	!The boundary to be searched.
  101      FORMAT (I2,1X,A4,"|",3I11,"|",$)				!This line will be continued.
           NCHECK = 0		!No new positions have been prepared.
           NLOOK = 0		!So the stashes have not been searched for any of them.
           PROBES = 0		!And no probes have been made in any such searches.
           MAXP = 0		!So the maximum length of all probe chains is zero so far.
           HNEXT = LST(W) + 1	!This will be where the first new position will be stashed.
           T1 = NOWWAS(0)	!Note the accumulated CPU time at the start of the boundary ride..
           E1 = NOWWAS(2)	!Time of day, in seconds. GMT style (thus not shifted by daylight saving)
        PP:DO P = IST(W),LST(W)	!These are on the edge of the tide. Spreading proceeds.
             READ (WRK(W),REC = P + 1) ASTASH	!Obtain a position, remembering to dodge the header record.
             HENCE = ASTASH.MOVE		!The move (from ASTASH.PREV) that reached this position.
             IF (HENCE.NE.0) HENCE = MOD(HENCE + 1,4) + 1	!The reverse of that direction. Only once zero. Sigh.
             CALL UNCRAM(ASTASH.BRD,BOARD)	!Unpack into the work BOARD.
             LZ = INDEX(BOAR,CHAR(0))	!Find the BOARD square with zero.
             ZR =    (LZ - 1)/NC + 1	!Convert to row and column in LOCZ to facilitate bound checking.
             ZC = MOD(LZ - 1,NC) + 1	!Two divisions, sigh. Add a special /\ syntax? (ZR,ZC) = (LZ - 1)/\NC + 1
Consider all possible moves from position P, If a new position is unknown, add it to the stash.
          DD:DO D = 1,4			!Step through the possible directions in which the zero square might move.
               IF (D.EQ.HENCE) CYCLE DD		!Don't try going back whence this came.
               LOCI = LOCZ + WAYS(1:2,D)	!Finger the destination of the zero square, (row,column) style.
               IF (ANY(LOCI.LE.0)) CYCLE DD	!No wrapping left/right or top/bottom.
               IF (ANY(LOCI.GT.(/NR,NC/))) CYCLE DD	!No .OR. to avoid the possibility of non-shortcut full evaluation.
               NCHECK = NCHECK + 1		!So, here is another position to inspect.
               NP = 0				!No probes of stashes W or M for it have been made.
               IT = WAY(D) + LZ			!Finger the square that is to move to the adjacent zero.
               BOARD(LZ) = BOARD(IT)		!Move that square's content to the square holding the zero.
               BOARD(IT) = 0			!It having departed.
               ASTASH.BRD(1) = BORED(1)*16 + BORED(2)	!Pack the position list
               ASTASH.BRD(2) = BORED(3)*16 + BORED(4)	!Without fussing over adjacency,
               HIT = ABS(MOD(ASTASH.BRD(1)*ASTASH.BRD(2),APRIME)) + 2	!Crunch the hash index.
               READ (NDX(W),REC = HIT) HEAD	!Refer to the index, which fingers the first place to look.
               LOOK = HEAD			!This may be the start of a linked-list.
               IF (LOOK.EQ.0) NINDEX(W) = NINDEX(W) + 1	!Or, a new index entry will be made.
               IF (LOOK.NE.0) NLOOK(1) = NLOOK(1) + 1	!Otherwise, we're looking at a linked-list, hopefully short.
               DO WHILE (LOOK.NE.0)		!Is there a stash entry to look at?
                 NP(1) = NP(1) + 1			!Yes. Count a probe of the W stash.
                 READ (WRK(W),REC = LOOK + 1) APROBE	!Do it. (Dodging the header record)
                 IF (ALL(ASTASH.BRD.EQ.APROBE.BRD)) GO TO 109	!Already seen? Ignore all such as previously dealt with.
                 LOOK = APROBE.NEXT			!Perhaps there follows another entry having the same index.
               END DO				!And eventually, if there was no matching entry,
               HCOUNT(W) = HCOUNT(W) + 1	!A new entry is to be added to stash W, linked from its index.
               IF (HCOUNT(W).LE.0) STOP "HCOUNT overflows!"	!Presuming the usual two's complement style.
               WRITE (NDX(W),REC = HIT) HCOUNT(W)	!The index now fingers the new entry in ASTASH.
               ASTASH.NEXT = HEAD			!Its follower is whatever the index had fingered before.
               ASTASH.PREV = P			!This is the position that led to it.
               ASTASH.MOVE = D			!Via this move.
               WRITE (WRK(W),REC = HCOUNT(W) + 1) ASTASH	!Place the new entry, dodging the header.
Check the other stash for this new position. Perhaps there, a meeting will be found!
               READ (NDX(M),REC = HIT) LOOK	!The other stash uses the same hash function but has its own index.
               IF (LOOK.NE.0) NLOOK(2) = NLOOK(2) + 1	!Perhaps stash M has something to look at.
               DO WHILE(LOOK.NE.0)		!Somewhere along a linked-list.
                 NP(2) = NP(2) + 1			!A thorough look may involve multiple probes.
                 READ(WRK(M),REC = LOOK + 1) APROBE	!Make one.
                 IF (ALL(ASTASH.BRD.EQ.APROBE.BRD)) THEN!A match?
                   IF (NMET.LT.MANY) THEN			!Yes! Hopefully, not too many already.
                     NMET = NMET + 1					!Count another.
                     MET(W,NMET) = HCOUNT(W)				!Save a finger to the new entry.
                     MET(M,NMET) = LOOK					!And to its matching counterparty.
                    ELSE						!But if too numerous for my list,
                     WRITE (MSG,108) TIDE(W),HCOUNT(W),TIDE(M),LOOK	!Announce each.
  108                FORMAT ("Can't save ",A,1X,I0," matching ",A,1X,I0)!Also wrecking my tabular layout.
                   END IF						!So much for recording a match.
                   GO TO 109					!Look no further for the new position; it is found..
                 END IF					!So much for a possible match.
                 LOOK = APROBE.NEXT			!Chase along the linked-list.
               END DO				!Thus checking all those hashing to the same index.
Completed the probe.
  109          MAXP = MAX(MAXP,NP)		!Track the maximum number of probes in any search..
               PROBES = PROBES + NP		!As well as their count.
               BOARD(IT) = BOARD(LZ)		!Finally, undo the move.
               BOARD(LZ) = 0			!To be ready for the next direction.
             END DO DD			!Consider another direction.
           END DO PP		!Advance P to the next spreading possibility.
Completed one perimeter sequence. Cast forth some statistics.
  110      T2 = NOWWAS(0)	!A boundary patrol has been completed.
           E2 = NOWWAS(2)	!And time has passed.
           HIT = HCOUNT(W) - HNEXT + 1	!The number of new positions to work from in the next layer.
           WRITE (MSG,111) NCHECK,100.0*(NCHECK - HIT)/NCHECK,	!Tested, and %already seen
     1      NLOOK(1),MAXP(1),FLOAT(PROBES(1))/MAX(NLOOK(1),1),	!Search statistics.
     2      100.0*NINDEX(W)/APRIME,100.0*HCOUNT(W)/APRIME,	!Index occupancy: used entries, and load.
     3      NLOOK(2),MAXP(2),FLOAT(PROBES(2))/MAX(NLOOK(2),1)	!Other stash's search statistics.
  111      FORMAT (I11,F9.2,"|",I11,I6,F7.3,"|",F8.3,F10.3,"|",	!Attempt to produce regular columns.
     1      I11,I6,F7.3,"|"$)					!To be continued...
           T1 = T2 - T1			!Thus, how much CPU time was used perusing the perimeter.
           E1 = E2 - E1			!Over the elapsed time.
           CALL PROUST(T1)		!Muse over the elapsed CPU time, in seconds.
           CALL PROUST(E1)		!And likewise the elapsed clock time.
           E2 = NOWWAS(1)		!Civil clock, possibly adjusted for daylight saving.
           IF (E1.LE.0) THEN		!The offered timing may be too coarse.
             WRITE (MSG,112) HMS(E2)		!So, just finish the line.
  112        FORMAT (8X,A)			!With a time of day.
            ELSE			!But if some (positive) clock time was measured as elapsing,
             WRITE (MSG,113) T1/E1*100,HMS(E2)	!Offer a ratio as well.
  113        FORMAT (F6.2,"%",1X,A)		!Percentages are usual.
           END IF			!Enough annotation.
Could there be new positions to check? HCOUNT will have been increased if so.
           SURGED(W) = HCOUNT(W).GE.HNEXT	!The boundary has been extended to new positions.
           IF (SURGED(W)) THEN		!But, are there any new positions?
             IST(W) = HNEXT			!Yes. The first new position would have been placed here.
             LST(W) = HCOUNT(W)			!This is where the last position was placed.
             SURGE(W) = SLOSH			!The new surge is ready.
             WRITE (WRK(W),REC = 1) HCOUNT(W),SURGE(W),IST(W),LST(W)	!Update the headers correspondingly..
             WRITE (NDX(W), REC = 1) NINDEX(W)	!Otherwise, a rescan would be needed on a restart.
           ELSE IF (SURGE(W) + 1 .EQ. SLOSH) THEN	!No new positions. First encounter?
             LOOK = LST(W) - IST(W) + 1		!Yes. How many dead ends are there?
             WRITE (MSG,114) LOOK		!Announce.
  114        FORMAT (/,"The boundary has not surged to new positions!",/
     1       "The now-static boundary has ",I0)
             LOOK = LOOK/666 + 1		!If there are many, don't pour forth every one.
             IF (LOOK.GT.1) WRITE (MSG,115) LOOK!Some restraint.
  115        FORMAT (6X,"... Listing step: ",I0)!Rather than rolling forth a horde.
             WRITE (MSG,121)			!Re-use the heading for the REPORT.
             DO P = IST(W),LST(W),LOOK		!Step through the dead ends, possibly sampling every one.
               READ (WRK(W),REC = P + 1) ASTASH		!Grab a position.
               CALL REPORT(P,TIDE(W),WNAMEF(ASTASH.MOVE),ASTASH.BRD)	!Describe it.
             END DO				!On to the next dead end.
           END IF			!Perhaps the universe has been filled.
Could the clouds have touched? If so, two trails have met.
  120   ML:DO P = 1,NMET		!Step through the meeting list.
             IF (NS.LT.MANY) NS = NS + 1!Note another shove sequence.
             LS(NS) = 0			!Details to be determined.
             WRITE (MSG,121)		!Announce, via a heading.
  121         FORMAT (/,5X,"Record Stash Move |Board layout by row|",	!Various details
     1         2X,"Max|d|  Sum|d|   Euclidean   Encoded vs Zero")	!Will be attached.
             NTRAIL = 1			!Every trail starts with its first step.
             TRAIL(1) = MET(2,P)	!This is the blue trail's position that met the red tide..
  122        READ(WRK(2),REC = TRAIL(NTRAIL) + 1) ASTASH	!Obtain details
             IF (ASTASH.PREV.NE.0) THEN	!Had this step arrived from somewhere?
               IF (NTRAIL.GE.LONG) STOP "The trail is too long!"	!Yes.
               NTRAIL = NTRAIL + 1		!Count another step.
               TRAIL(NTRAIL) = ASTASH.PREV	!Finger the preceding step.
               GO TO 122			!And investigate it in turn.
             END IF			!Thus follow the blue trail back to its origin.
  130        DO LOOK = NTRAIL,1,-1	!The end of the blue trail is the position in TARGET, the start position.
               READ(WRK(2),REC = TRAIL(LOOK) + 1) ASTASH	!Grab a position, dodging the header.
               CALL REPORT(TRAIL(LOOK),"Blue",WNAMEF(ASTASH.MOVE),	!Backwards*backwards = forwards.
     1          ASTASH.BRD)						!The board layout is always straightforward...
               IF (LOOK.NE.NTRAIL) THEN		!The start position has no move leading to it.
                 IF (LS(NS).LT.LEN(SHOVE(1))) LS(NS) = LS(NS) + 1	!But count all subsequent ssociated moves.
                 SHOVE(NS)(LS(NS):LS(NS)) = WNAMEF(ASTASH.MOVE)	!Place it.
               END IF				!So much for that move.
             END DO			!On to the next move away from the start position.
  140        HEAD = 0			!Syncopation. Prevent the first position of the red trail from being listed.
             LOOK = MET(1,P)		!It is the same position as the first in the TRAIL, but in the primary stash.
             DO WHILE(LOOK.NE.0)	!The red chain runs back to its starting position, which is the "solution" state..
               READ(WRK(1),REC = LOOK + 1) ASTASH	!Which is in the direction I want to list.
               IF (HEAD.NE.0) THEN			!Except that the moves are one step behind for this list.
                 CALL REPORT(LOOK,"Red",WNAMEZ(HEAD),ASTASH.BRD)	!As this sequence is not being reversed.
                 IF (LS(NS).LT.LEN(SHOVE(1))) LS(NS) = LS(NS) + 1	!This lists the moves in forwards order.
                 SHOVE(NS)(LS(NS):LS(NS)) = WNAMEZ(HEAD)	!But the directions are reversed....
               END IF				!This test avoids listing the "Red" position that is the same as the last "Blue" position.
               HEAD = ASTASH.MOVE		!This is the move that led to this position.
               LOOK = ASTASH.PREV		!From the next position, which will be listed next.
             END DO			!Thus, the listed position was led to by the previous position's move.
  150        DO I = 1,NS - 1		!Perhaps the move sequence has been found already.
               IF (SHOVE(I)(1:LS(I)).EQ.SHOVE(NS)(1:LS(NS))) THEN	!So, compare agains previous shoves.
                 WRITE (MSG,151) I				!It has been seen.
  151            FORMAT (6X,"... same as for sequence ",I0)	!Humm.
                 NS = NS - 1					!Eject the arriviste.
                 GO TO 159					!And carry on.
               END IF				!This shouldn't happen...
             END DO			!On to the next comparison.
             WRITE (MSG,152) LS(NS),SHOVE(NS)(1:LS(NS))	!Show the moves along a line.
  152        FORMAT (I4," moves: ",A)	!Surely plural? One-steps wouldn't be tried?
  159      END DO ML		!Perhaps another pair of snakes have met.
         END DO WW	!Advance W to the other one. M will be swapped correspondingly.

Could there be an end to it all?
         IF (.NOT.ANY(SURGED)) STOP "No progress!"	!Oh dear.
         IF (NMET.LE.0) GO TO 100			!Keep right on to the end of the road...
       END SUBROUTINE PURPLE HAZE	!That was fun!
      END MODULE SLIDESOLVE

      PROGRAM POKE
      USE SLIDESOLVE
      CHARACTER*(19) FNAME		!A base name for some files.
      INTEGER I,R,C			!Some steppers.
      INTEGER MSG,KBD,WRK(2),NDX(2)	!I/O unit numbers.
      COMMON/IODEV/ MSG,KBD,WRK,NDX	!I talk to the trees..
      KBD = 5			!Standard input. (Keyboard)
      MSG = 6			!Standard output.(Display screen)
      WRK = (/10,12/)		!I need two work files,
      NDX = WRK + 1		!Each with its associated index.
      WRITE (FNAME,1) NR,NC	!Now prepare the file name.
    1 FORMAT ("SlideSolveR",I1,"C",I1,".txt")	!Allowing for variation, somewhat.
      WRITE (MSG,2) NR,NC,FNAME			!Announce.
    2 FORMAT ("To play 'slide-square' with ",I0," rows and ",
     1 I0," columns.",/,"An initial layout will be read from file ",
     2 A,/,"The objective is to attain the nice orderly layout"
     3 " as follows:",/)
      FORALL(I = 1:N - 1) ZERO(I) = I	!Regard the final or "solution" state as ZERO.
      ZERO(N) = 0			!The zero sqiuare is at the end, damnit!
      CALL SHOW(NR,NC,ZERO)		!Show the squares in their "solved" arrangement: the "Red" stash.
      OPEN(WRK(1),FILE=FNAME,STATUS="OLD",ACTION="READ")	!For formatted input.
      DO R = 1,NR			!Chug down the rows, reading successive columns across a row..
        READ (WRK(1),*) (TARGET((R - 1)*NC + C), C = 1,NC)	!Into successive storage locations.
      END DO				!Furrytran's storage order is (column,row) for that, alas.
      CLOSE (WRK(1))			!A small input, but much effort follows.
      WRITE (MSG,3)			!Now show the supplied layout.
    3 FORMAT (/,"The starting position:")	!The target, working backwards.
      CALL SHOW(NR,NC,TARGET)		!This will be the starting point for the "Blue" stash.
      IF (ALL(TARGET.EQ.BOARD)) STOP "Huh? They're the same!"	!Surely not.
      WRITE (MSG,4)
    4 FORMAT (/'The plan is to spread a red tide from the "solved" ',
     1 "layout and a blue tide from the specified starting position.",/
     2 "The hope is that these floods will meet at some position,",
     3 " and the blue moves plus the red moves in reverse order,",/
     4 "will be the shortest sequence from the given starting",
     5 " position to the solution.")

      CALL PURPLE HAZE(FNAME(1:14))

      END
