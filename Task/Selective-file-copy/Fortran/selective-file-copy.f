      PROGRAM TEST	!Define some data aggregates, then write and read them.
      TYPE PLACE
       INTEGER		N
       CHARACTER*28	PLACENAME
       REAL		ALTITUDE
       COMPLEX		LATLONG
      END TYPE PLACE
      TYPE HOME
       CHARACTER*28	PLACENAME
       COMPLEX		LATLONG
      END TYPE HOME
      TYPE (PLACE) HERE,THERE	!I'll have two.
      TYPE (HOME) IS		!And one of this.
      NAMELIST /STUFF/ HERE,THERE,IS	!A collection.
      INTEGER F	!An I/O unit number.
      F = 10	!This will do.

Create an example file to show its format.
      OPEN(F,FILE="Test.txt",STATUS="REPLACE",ACTION="WRITE",	!First, prepare a recipient file.
     1 DELIM="QUOTE")	!CHARACTER variables will be enquoted.
      HERE = PLACE(1,"Mt. Cook trig.",20.0,(-41.29980555,174.77629))	!Base position for surveying.
      THERE = HERE		!Copy one data aggregate to another.
      THERE.N = 2		!Differentiate.
      IS.PLACENAME = "Taipou."	!Initialise another,
      IS.LATLONG = (0,0)	!Piecemeal.
      WRITE (F,STUFF)		!Write the lot in one go.
      CLOSE (F)			!Finished with output.
      HERE = PLACE(0,"",0,(0,0))!Scrub the variables.
      THERE = HERE
      IS = HOME("",(0,0))
Can now read from the file.
      OPEN(F,FILE="Test.txt",STATUS="OLD",ACTION="READ",	!Get it back.
     1 DELIM="QUOTE")	
      READ (F,STUFF)			!Read who knows what.
      IS.PLACENAME = HERE.PLACENAME	!Copy some particular portion.
      IS.LATLONG = HERE.LATLONG		!Piecemeal, as no common structure was defined.
      WRITE (6,*) IS			!Reveal the result.
      END
