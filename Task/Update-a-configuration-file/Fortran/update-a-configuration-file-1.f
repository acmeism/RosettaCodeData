      PROGRAM TEST	!Define some data aggregates, then write and read them.
      CHARACTER*28 FAVOURITEFRUIT
      LOGICAL NEEDSPEELING
      LOGICAL SEEDSREMOVED
      INTEGER NUMBEROFBANANAS
      NAMELIST /FRUIT/ FAVOURITEFRUIT,NEEDSPEELING,SEEDSREMOVED,
     1 NUMBEROFBANANAS
      INTEGER F	!An I/O unit number.
      F = 10	!This will do.

Create an example file to show its format.
      OPEN(F,FILE="Basket.txt",STATUS="REPLACE",ACTION="WRITE",	!First, prepare a recipient file.
     1 DELIM="QUOTE")	!CHARACTER variables will be enquoted.
      FAVOURITEFRUIT = "Banana"
      NEEDSPEELING = .TRUE.
      SEEDSREMOVED = .FALSE.
      NUMBEROFBANANAS = 48
      WRITE (F,FRUIT)		!Write the lot in one go.
      CLOSE (F)			!Finished with output.
Can now read from the file.
      OPEN(F,FILE="Basket.txt",STATUS="OLD",ACTION="READ",	!Get it back.
     1 DELIM="QUOTE")
      READ (F,FRUIT)			!Read who knows what.
      WRITE (6,FRUIT)
      END
