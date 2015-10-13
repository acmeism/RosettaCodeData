       MODULE DATEGNASH	!Assorted vexations. Time and calendar games, with local flavourings added.

       TYPE DateBag		!Pack three parts into one.
        INTEGER DAY,MONTH,YEAR	!The usual suspects.
       END TYPE DateBag		!Simple enough.

       CHARACTER*9 MONTHNAME(12),DAYNAME(0:6)	!Re-interpretations.
       PARAMETER (MONTHNAME = (/"January","February","March","April",
     1  "May","June","July","August","September","October","November",
     2  "December"/))
       PARAMETER (DAYNAME = (/"Sunday","Monday","Tuesday","Wednesday",
     1  "Thursday","Friday","Saturday"/))	!Index this array with DayNum mod 7.
       CHARACTER*3 MTHNAME(12)		!The standard abbreviations.
       PARAMETER (MTHNAME = (/"JAN","FEB","MAR","APR","MAY","JUN",
     1  "JUL","AUG","SEP","OCT","NOV","DEC"/))

       INTEGER*4 JDAYSHIFT		!INTEGER*2 just isn't enough.
       PARAMETER (JDAYSHIFT = 2415020)	!Thus shall 31/12/1899 give 0, a Sunday, via DAYNUM.
       CONTAINS
       INTEGER FUNCTION LSTNB(TEXT)  !Sigh. Last Not Blank.
Concocted yet again by R.N.McLean (whom God preserve) December MM.
Code checking reveals that the Compaq compiler generates a copy of the string and then finds the length of that when using the latter-day intrinsic LEN_TRIM. Madness!
Can't   DO WHILE (L.GT.0 .AND. TEXT(L:L).LE.' ')	!Control chars. regarded as spaces.
Curse the morons who think it good that the compiler MIGHT evaluate logical expressions fully.
Crude GO TO rather than a DO-loop, because compilers use a loop counter as well as updating the index variable.
Comparison runs of GNASH showed a saving of ~3% in its mass-data reading through the avoidance of DO in LSTNB alone.
Crappy code for character comparison of varying lengths is avoided by using ICHAR which is for single characters only.
Checking the indexing of CHARACTER variables for bounds evoked astounding stupidities, such as calculating the length of TEXT(L:L) by subtracting L from L!
Comparison runs of GNASH showed a saving of ~25-30% in its mass data scanning for this, involving all its two-dozen or so single-character comparisons, not just in LSTNB.
        CHARACTER*(*),INTENT(IN):: TEXT	!The bumf. If there must be copy-in, at least there need not be copy back.
        INTEGER L		!The length of the bumf.
         L = LEN(TEXT)		!So, what is it?
    1    IF (L.LE.0) GO TO 2	!Are we there yet?
         IF (ICHAR(TEXT(L:L)).GT.ICHAR(" ")) GO TO 2	!Control chars are regarded as spaces also.
         L = L - 1		!Step back one.
         GO TO 1		!And try again.
    2    LSTNB = L		!The last non-blank, possibly zero.
        RETURN			!Unsafe to use LSTNB as a variable.
       END FUNCTION LSTNB	!Compilers can bungle it.
      CHARACTER*2 FUNCTION I2FMT(N)	!These are all the same.
       INTEGER*4 N			!But, the compiler doesn't offer generalisations.
        IF (N.LT.0) THEN	!Negative numbers cop a sign.
          IF (N.LT.-9) THEN	!But there's not much room left.
            I2FMT = "-!"	!So this means 'overflow'.
           ELSE			!Otherwise, room for one negative digit.
            I2FMT = "-"//CHAR(ICHAR("0") - N)	!Thus. Presume adjacent character codes, etc.
          END IF		!So much for negative numbers.
        ELSE IF (N.LT.10) THEN	!Single digit positive?
          I2FMT = " " //CHAR(ICHAR("0") + N)	!Yes. This.
        ELSE IF (N.LT.100) THEN	!Two digit positive?
          I2FMT = CHAR(N/10      + ICHAR("0"))	!Yes.
     1           //CHAR(MOD(N,10) + ICHAR("0")) !These.
        ELSE			!Otherwise,
          I2FMT = "+!" 	!Positive overflow.
        END IF			!So much for that.
      END FUNCTION I2FMT	!No WRITE and FORMAT unlimbering.
      CHARACTER*8 FUNCTION I8FMT(N)	!Oh for proper strings.
       INTEGER*4 N
       CHARACTER*8 HIC
        WRITE (HIC,1) N
    1   FORMAT (I8)
        I8FMT = HIC
      END FUNCTION I8FMT

      SUBROUTINE SAY(OUT,TEXT)	!Gutted version that maintains no file logging output, etc.
       INTEGER OUT
       CHARACTER*(*) TEXT
        WRITE (6,1) TEXT(1:LSTNB(TEXT))
    1   FORMAT (A)
      END SUBROUTINE SAY

       INTEGER*4 FUNCTION DAYNUM(YY,M,D)	!Computes (JDayN - JDayShift), not JDayN.
C   Conversion from a Gregorian calendar date to a Julian day number, JDayN.
C   Valid for any Gregorian calendar date producing a Julian day number
C greater than zero, though remember that the Gregorian calendar
C was not used before y1582m10d15 and often, not after that either.
C thus in England (et al) when Wednesday 2'nd September 1752 (Julian style)
C was followed by Thursday the 14'th, occasioning the Eleven Day riots
C because creditors demanded a full month's payment instead of 19/30'ths.
C   The zero of the Julian day number corresponds to the first of January
C 4713BC on the *Julian* calendar's naming scheme, as extended backwards
C with current usage into epochs when it did not exist: the proleptic Julian calendar.
c This function employs the naming scheme of the *Gregorian* calendar,
c and if extended backwards into epochs when it did not exist (thus the
c proleptic Gregorian calendar) it would compute a zero for y-4713m11d24 *if*
c it is supposed there was a year zero between 1BC and 1AD (as is convenient
c for modern mathematics and astronomers and their simple calculations), *but*
c 1BC immediately preceeds 1AD without any year zero in between (and is a leap year)
c thus the adjustment below so that the date is y-4714m11d24 or 4714BCm11d24,
c not that this name was in use at the time...
c   Although the Julian calendar (introduced by himself in what we would call 45BC,
c which was what the Romans occasionally called 709AUC) was provoked by the
c "years of confusion" resulting from arbitrary application of the rules
c for the existing Roman calendar, other confusions remain unresolved,
c so precise dating remains uncertain despite apparently precise specifications
c (and much later, Dennis the Short chose wrongly for the birth of Christ)
c and the Roman practice of inclusive reckoning meant that every four years
c was interpreted as every third (by our exclusive reckoning) so that the
c leap years were not as we now interpret them. This was resolved by Augustus
c but exactly when (and what date name is assigned) and whose writings used
c which system at the time of writing is a matter of more confusion,
c and this has continued for centuries.
C   Accordingly, although an algorithm may give a regular sequence of date names,
c that does not mean that those date names were used at the time even if the
c calendar existed then, because the interpretation of the algorithm varied.
c This in turn means that a date given as being on the Julian calendar
c prior to about 10AD is not as definite as it may appear and its alignment
c with the astronomical day number is uncertain even though the calculation
c is quite definite.
c
C   Computationally, year 1 is preceded by year 0, in a smooth progression.
C But there was never a year zero despite what astronomers like to say,
C so the formula's year 0 corresponds to 1BC, year -1 to 2BC, and so on back.
C Thus y-4713 in this counting would be 4714BC on the Gregorian calendar,
C were it to have existed then which it didn't.
C   To conform to the civil usage, the incoming YY, presumed a proper BC (negative)
C and AD (positive) year is converted into the computational counting sequence, Y,
C and used in the formula. If a YY = 0 is (improperly) offered, it will manifest
C as 1AD. Thus YY = -4714 will lead to calculations with Y = -4713.
C Thus, 1BC is a leap year on the proleptic Gregorian calendar.
C   For their convenience, astronomers decreed that a day starts at noon, so that
C in Europe, observations through the night all have the same day number.
C The current Western civil calendar however has the day starting just after midnight
C and that day's number lasts until the following midnight.
C
C   There is no constraint on the values of D, which is just added as it stands.
C This means that if D = 0, the daynumber will be that of the last day of the
C previous month. Likewise, M = 0 or M = 13 will wrap around so that Y,M + 1,0
C will give the last day of month M (whatever its length) as one day before
C the first day of the next month.
C
C   Example: Y = 1970, M = 1, D = 1;  JDAYN = 2440588, a Thursday but MOD(2440588,7) = 3.
C   and with the adjustment JDAYSHIFT, DAYNUM = 25568; mod 7 = 4 and DAYNAME(4) = "Thursday".
C   The Julian Day number 2440588.0 is for NOON that Thursday, 2440588.5 is twelve hours later.
C   And Julian Day number 2440587.625 is for three a.m. Thursday.
C
C   DAYNUM and MUNYAD are the infamous routines of H. F. Fliegel and T.C. van Flandern,
C   presented in Communications of the ACM, Vol. 11, No. 10 (October, 1968).
Carefully typed in again by R.N.McLean (whom God preserve) December XXMMIIX.
C   Though I remain puzzled as to why they used I,J,K for Y,M,D,
C given that the variables were named in the INTEGER statement anyway.
        INTEGER*4 JDAYN		!Without rebasing, this won't fit in INTEGER*2.
        INTEGER YY,Y,M,MM,D	!NB! Full year number, so 1970, not 70.
Caution: integer division in Fortran does not produce fractional results.
C The fractional part is discarded so that 4/3 gives 1 and -4/3 gives -1.
C Thus 4/3 might be Trunc(4/3) or 4 div 3 in other languages. Beware of negative numbers!
         Y = YY		!I can fiddle this copy without damaging the original's value.
         IF (Y.LT.1) Y = Y + 1	!Thus YY = -2=2BC, -1=1BC, +1=1AD, ... becomes Y = -1, 0, 1, ...
         MM = (M - 14)/12	!Calculate once. Note that this is integer division, truncating.
         JDAYN = D - 32075	!This is the proper astronomer's Julian Day Number.
     a    + 1461*(Y + 4800  + MM)/4
     b    +  367*(M - 2     - MM*12)/12
     c    -    3*((Y + 4900 + MM)/100)/4
         DAYNUM = JDAYN - JDAYSHIFT	!Thus, *NOT* the actual *Julian* Day Number.
       END FUNCTION DAYNUM		!But one such that Mod(n,7) gives day names.

Could compute the day of the year somewhat as follows...
c  DN:=D + (61*Month + (Month div 8)) div 2 - 30
c        + if Month > 2 then FebLength - 30 else 0;

       TYPE(DATEBAG) FUNCTION MUNYAD(DAYNUM)	!Oh for palindromic programming!
Conversion from a Julian day number to a Gregorian calendar date. See JDAYN/DAYNUM.
        INTEGER*4 DAYNUM,JDAYN	!Without rebasing, this won't fit in INTEGER*2.
        INTEGER Y,M,D,L,N		!Y will be a full year number: 1950 not 50.
         JDAYN = DAYNUM + JDAYSHIFT	!Revert to a proper Julian day number.
         L = JDAYN + 68569	!Further machinations of H. F. Fliegel and T.C. van Flandern.
         N = 4*L/146097
         L = L - (146097*N + 3)/4
         Y = 4000*(L + 1)/1461001
         L = L - 1461*Y/4 + 31
         M = 80*L/2447
         D = L - 2447*M/80
         L = M/11
         M = M + 2 - 12*L
         Y = 100*(N - 49) + Y + L
         IF (Y.LT.1) Y = Y - 1	!The other side of conformity to BC/AD, as in DAYNUM.
         MUNYAD%YEAR  = Y	!Now place for the world to see.
         MUNYAD%MONTH = M
         MUNYAD%DAY   = D
       END FUNCTION MUNYAD	!A year has 365.2421988 days...

       INTEGER FUNCTION PMOD(N,M)	!Remainder, mod M; always positive even if N is negative.
c   For date calculations, the MOD function is expected to yield positive remainders,
c in line with the idea that MOD(a,b) = MOD(a ± b,b) as is involved in shifting the zero
c of the daynumber count by a multiple of seven when considering the day of the week.
c For this reason, the zero day was chosen to be 31/12/1899, a Sunday, so that all
c day numbers would be positive. But, there was generation at Reefton in 1886.
c   For some computers, the positive interpretation is implemented, for others, not.
c In the case MOD(N,M) = N - Truncate(N/M)*M, MOD(-6,7) = -6 even though MOD(1,7) = 1.
        INTEGER N,M			!The numbers. M presumed positive.
         PMOD = MOD(MOD(N,M) + M,M)	!Double do does de deed.
       END FUNCTION PMOD		!Simple enough.

      SUBROUTINE CALENDAR(Y1,Y2,COLUMNS)	!Print a calendar, with holiday annotations.
Careful with the MOD function. MOD(-6,7) may be negative on some systems, positive on others. Thus, PMOD.
       INTEGER Y1,Y2,YEAR		!Ah yes. Year stuff.
       INTEGER M,M1,M2,MONTH		!And within each year are the months.
       INTEGER*4 DN1,DN2,DN,D		!But days are handled via day numbers.
       INTEGER W,G			!Layout: width and gap.
       INTEGER L,LINE			!Vertical layout.
       INTEGER COL,COLUMNS,COLWIDTH	!Horizontal layout.
       INTEGER CODE			!Days are not all alike.
       CHARACTER*200 STRIPE(6),SPECIAL(6),MLINE,DLINE	!Scratchpads.
        IF (Y1.LE.0) CALL SAY(MSG,"Despite the insinuations of "
     1   //"astronomers seduced by the ease of their arithmetic, "
     2   //"there is no year zero. 1AD is preceded by 1BC, "
     3   //"corresponding to year -1, 2BC to year -2, etc.")
        IF (Y1.LT.1582) CALL SAY(MSG,"This Gregorian calendar"
     1   //" scheme did not exist prior to 1582.")
c        COLUMNS = 4	!Number of months across the page.
c        W = 4		!Width of a day's field.
c        G = 3		!Added gap between month columns.
        W = 3		!Abandon the annotation of the day's class, so just a space and two digits.
        G = 1		!
        COLWIDTH = 7*W + G	!Seven days to a week, plus a gap.
      Y:DO YEAR = Y1,Y2		!Step through the years.
          CALL SAY(MSG,"")	!Space out between each year's schedule.
          IF (YEAR.EQ.0) THEN	!This year number is improper.
            CALL SAY(MSG,"There is no year zero.")	!Declare correctness.
            CYCLE Y		!Skip this year.
          END IF		!Otherwise, no evasions.
          MLINE = ""		!Prepare a field..
          L = (COLUMNS*COLWIDTH - G - 8)/2	!Find the centre.
          IF (YEAR.GT.0) THEN	!Ordinary Anno Domine years?
            MLINE(L:) = I8FMT(YEAR)	!Yes. Place the year number.
           ELSE			!Otherwise, we're in BC.
            MLINE(L - 1:) = I8FMT(-YEAR)//"BC"	!There is no year zero.
          END IF		!So much for year games.
          CALL SAY(MSG,MLINE)		!Splot the year.
          DO MONTH = 1,12,COLUMNS	!Step through the months of this YEAR.
            M1 = MONTH			!The first of this lot.
            M2 = MIN(12,M1 + COLUMNS - 1)	!The last.
            MLINE = ""			!Scrub the month names.
            DLINE = ""			!Wipe the day names in case COLUMNS does not divide 12.
            STRIPE = ""			!Scrub the day table.
            SPECIAL = ""		!And the associated special day remarks.
c            L0 = W - 1			!Locate the first day number's first column.
            L0 = 1			!Cram: no space in front of the Sunday day-of-the-month.
            DO M = M1,M2		!Work through the months.
              L = (COLWIDTH - G - LSTNB(MONTHNAME(M)))/2 - 1	!Centre the month name.
              MLINE(L0 + L:) = MONTHNAME(M)	!Splot.
              DO D = 0,6		!Prepare this month's day name heading.
                L = L0 + (3 - W) + D*W	!Locate its first column.
                DLINE(L:L + 2) = DAYNAME(D)(1:W - 1)	!Squish.
              END DO		!On to the next day.
              DN1 = DAYNUM(YEAR,M,1)	!Day number of the first day of the month.
              DN2 = DAYNUM(YEAR,M + 1,0)!Thus the last, without annoyance.
              COL = MOD(PMOD(DN1,7) + 7,7)	!What day of the week is the first day?
              LINE = 1			!Whichever it is, it is on the first line.
              D = 1			!Day of the month, not number of the day.
              DO DN = DN1,DN2		!Step through the day numbers of this month.
                L = L0 + COL*W		!Finger the starting column.
                STRIPE(LINE)(L:L + 1) = I2FMT(D)	!Place the two-digit day number.
                D = D + 1		!Advance to the next day of the current month
                COL = COL + 1		!So, one more day along in the week.
                IF (COL.GT.6) THEN	!A fresh week is needed?
                  LINE = LINE + 1	!Yes.
                  COL = 0		!Start the new week.
                END IF		!So much for the end of a week.
              END DO		!On to the next day of this month.
              L0 = L0 + 7*W + G	!Locate the start column of the next month's column.
            END DO	!On to the next month in this layer.
            CALL SAY(MSG,MLINE)	!Name the months.
C            CALL SAY(MSG,"")	!Set off.
            CALL SAY(MSG,DLINE)	!Give the day name headings.
            DO LINE = 1,6	!Now roll the day number table.
              IF (STRIPE(LINE).NE."") THEN	!Perhaps there was no use of the sixth line.
                CALL SAY(MSG,STRIPE(LINE))	!Ah well. Show the day numbers.
              END IF				!So much for that week line.
            END DO			!On to the next week line.
          END DO		!On to the next batch of months of the YEAR.
        END DO Y		!On to the next YEAR.
        CALL SAY(MSG,"")	!Take a breath.
      END SUBROUTINE CALENDAR	!Enough of this.
      END MODULE DATEGNASH	!An ad-hoc assemblage.

      PROGRAM SHOW1968		!Put it to the test.
       USE DATEGNASH
       INTEGER NCOL
        DO NCOL = 1,6
          CALL CALENDAR(1969,1969,NCOL)
        END DO
      END
