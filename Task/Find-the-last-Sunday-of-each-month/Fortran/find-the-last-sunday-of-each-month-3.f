      MODULE DATEGNASH
C          Calculate conforming to complex calendarical contortions.
C   Astronomer Simon Newcomb determined that the tropical year of 1900
c contained 31556925.9747 seconds, or 365.24219879 days.
c Subsequent definitions involve "no measurable differences",
c whereas in 45BC (when the Julian calendar was adopted), the year was
c 365.24232 days long, going by modern calculations.
c   The "tropical" year is the time between the same equinoxes, and thus
c contains the effect of the precession of the Earth's axis, which would
c otherwise cause the seasons to likewise precess around the "fixed star"
c year, that being the time for midnight to point in the same direction
c amongst the "fixed" stars. Specifically, the vernal equinox
c (the northern hemisphere's spring equinox: cultural colonialism)
c is meant to hover around the 21'st of March, although it may fall
c within the 19'th or 20'th, which last has been the most popular in
c the 20'th century, until the leap year of 2000 resynchronised
c the civil calendar.
C   By contrast, the computations of astrologers are still based on the
c constellations as oriented in Babylonian times...

c   So, to add .24219879 to 365 days...
c   Adjustment per year   Nett     Discrepancy remaining.
c   +1/4     +.25        +.25      -.00780121  5h 48m 45.98s
c   -1/100   -.01         .24      +.00219879    -11m 14.02s
c   +1/400   +.0025       .2425    -.00030121        -26.02s
c   -1/4000  -.00025      .24225   -.00005121         -4.42s
c
c   The remnant of -.00005121 (meaning that the calendar year is too long)
c amounts to needing to drop one day on 19,527 years, and while this could be
c accommodated nicely enough by -1/20000 to give a calendar year of
c 365.24420 days with a remaining discrepancy of -.00000121 or -.01sec/year,
c there is a problem. The Earth's spin is slowing by a similar amount.
c   Similar to leap years and leap days are the leap seconds that since the
c development of clocks based on atomic oscillations, have been added or
c sometimes removed to keep clock time aligned with astronomical observations.
c This additional confusion is not further considered.

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
       DOUBLE PRECISION DAYSINYEAR	!A real ache.
       PARAMETER (DAYSINYEAR =  365.24219879D0)	!The "D0" demands DOUBLE PRECISION precision.
       INTEGER*4 SECONDSINDAY			!This has its uses.
       PARAMETER (SECONDSINDAY = 24*60*60)	!86400. Disregarding "leap" seconds.
       INTEGER NOTADAYNUMBER			!Might as well settle on one value.
       PARAMETER (NOTADAYNUMBER = -2147483648)	!And everyone use it.

       PARAMETER NZBASEPLACE = "Mt. Cook Trig, Wellington."	!Name the place.
       DOUBLE PRECISION NZBASELAT,NZBASELONG	!Alas, DATA statements do not allow arithmetic expressions.
       PARAMETER (NZBASELAT = -((59.3 D0/60 + 17)/60 +  41))	!Degrees South, thus negative.
       PARAMETER (NZBASELONG = ((34.65D0/60 + 46)/60 + 174))	!Degrees East are oriented as positive: left to right with N up.
C                                   Seconds  Minutes Degrees.
C   This is the location of the Mt. Cook trigonometrical base point for New Zealand.
C    (It's in the foyer of what used to be the Dominion Museum, Wellington)
C   Determined by Henry Jackson, chief surveyor, in 1870.

       TYPE Terroir	!Collate the attributes of location, as so far needed.
        CHARACTER*28 PLACENAME	!Name the location.
        DOUBLE PRECISION LATITUDE,LONGITUDE	!Locate the location.
        DOUBLE PRECISION ZONETIME	!The time zone of its civil clock, not necessarily a whole hour.
       END TYPE Terroir		!The nature of the climate, soil, etc. is not yet involved.
       TYPE(Terroir) BASE	!Righto, let's have one of them.
       DATA BASE/Terroir("Mt. Cook Trig, Wellington.",	!The compiler bungles if NZBASEPLACE is used here.
     1  NZBASELAT,NZBASELONG,+12.0)/	!Where it's at. +12 hours ahead = +180 degrees Eastward of Greenwhich.
Careful! New Zealand is not centred on longitude 180, but its civil clock's time zone is.
       DOUBLE PRECISION SINBASELAT,COSBASELAT	!Calculated in SOLARDIRECTION and ZAPME.

      CONTAINS			!Let the madness begin.

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
c 1BC immediately precedes 1AD without any year zero in between (and is a leap year)
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

       CHARACTER*10 FUNCTION SLASHDATE(DAYNUM)	!This is relatively innocent.
Caution! The Gregorian calendar did not exist prior to 15/10/1582!
Confine expected operation to four-digit years, since fixed-field sizes are in mind.
Can use this function in WRITE statements with FORMAT, since this function does not use them.
Compilers of lesser merit can concoct code that bungles such double usage otherwise.
        INTEGER*4 DAYNUM	!-32768 to 32767 is just not adequate.
        TYPE(DATEBAG) D		!Though these numbers are more restrained.
        INTEGER N,L		!Workers.
         IF (DAYNUM.EQ.NOTADAYNUMBER) THEN	!Perhaps some work can be dodged.
           SLASHDATE = " Undated!!"	!No proper day number has been placed.
          RETURN		!So give up, rather than show odd results.
         END IF			!So much for confusion.
         D = MUNYAD(DAYNUM)	!Get the pieces.
         IF (D%DAY.GT.9) THEN	!Here we go.
           SLASHDATE(1:1) = CHAR(D%DAY/10 + ICHAR("0"))	!Faster than a table look-up?
          ELSE			!Even if not,
           SLASHDATE(1:1) = " "	!This should be quick.
         END IF			!So much for the tens digit.
         SLASHDATE(2:2) = CHAR(MOD(D%DAY,10) + ICHAR("0"))	!The units digit.
         SLASHDATE(3:3) = "/"	!Enough of the day number. The separator.
         IF (D%MONTH.GT.9) THEN	!Now for the month.
           SLASHDATE(4:4) = CHAR(D%MONTH/10 + ICHAR("0"))	!The tens digit.
          ELSE			!Not so often used. A table beckons...
           SLASHDATE(4:4) = " "	!Some might desire leading zeroes here.
         END IF			!Enough of October, November and December.
         SLASHDATE(5:5) = CHAR(MOD(D%MONTH,10) + ICHAR("0"))	!The units digit.
         SLASHDATE(6:6) = "/"	!Enough of the month number. The separator.
         L = 10			!The year value deserves a loop, it having four digits.
         N = ABS(D%YEAR)	!Should never be zero. 1BC is year -1 and 1AD is year = +1.
    1    SLASHDATE(L:L) = CHAR(MOD(N,10) + ICHAR("0"))	!But if it is, this will place a zero.
         N = N/10		!Drop a power of ten.
         L = L - 1		!Step back for the next digit.
         IF (L.GT.6) GO TO 1	!Thus always four digits, even if they lead with zero.
         IF (N.GT.0) SLASHDATE(7:7) = "?"	!Y > 9999? Might as well do something.
         IF (D%YEAR.LT.0) SLASHDATE(7:7) = "-"	!Years BC? Rather than give no indication.
c         WRITE (SLASHDATE,1) D%DAY,D%MONTH,D%YEAR	!Some compilers will bungle this.
c    1    FORMAT (I2,"/",I2,"/",I4)			!If so, a local variable must be used.
        RETURN			!Enough.		!As when SLASHDATE is invoked in a WRITE statement.
       END FUNCTION SLASHDATE	!Simple enough.
      END MODULE DATEGNASH

      PROGRAM LASTSUNDAY
      USE DATEGNASH
      INTEGER D,W,M,Y
      WRITE (6,1)
    1 FORMAT ("Employs the Gregorian calendar pattern.",/,
     1 "You specify a day of the week, then nominate a year.",/,
     2 "For each month of that year, this calculates the date ",
     3 "of the last such day.",//
     4 "So, what day (0 = Sunday, 6 = Saturday):",$)
      READ (5,*) W
      IF (W.LT.0 .OR. W.GT.6) STOP "Not a good week day number!"

   10 WRITE (6,11)
   11 FORMAT ("What year (non-positive to quit):",$)
      READ (5,*) Y
      IF (Y.LE.0) STOP
      DO M = 1,12
        D = DAYNUM(Y,M + 1,0)	!Zeroth day = last day of previous month.
        D = D - MOD(MOD(D - W,7) + 7,7)	!Protect against MOD(D,7) giving negative values for D < 0.
        WRITE (6,*) SLASHDATE(D)," : ",DAYNAME(MOD(D,7))
      END DO
      GO TO 10
      END
