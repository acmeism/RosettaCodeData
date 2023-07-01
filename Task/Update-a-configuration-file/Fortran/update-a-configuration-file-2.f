      MODULE MONKEYFODDER
       INTEGER FIELD	!An I/O unit number.
       CHARACTER*28 FAVOURITEFRUIT
       LOGICAL NEEDSPEELING
       INTEGER NUMBEROFBANANAS
       CONTAINS
        SUBROUTINE GETVALS(FNAME)	!Reads values from some file.
         CHARACTER*(*) FNAME	!The file name.
         LOGICAL SEEDSREMOVED	!This variable is no longer wanted.
         NAMELIST /FRUIT/ FAVOURITEFRUIT,NEEDSPEELING,SEEDSREMOVED,	!But still appears in this list.
     1    NUMBEROFBANANAS
          OPEN(FIELD,FILE=FNAME,STATUS="OLD",ACTION="READ",	!Hopefully, the file exists.
     1     DELIM="QUOTE")	!Expect quoting for CHARACTER variables.
          READ (FIELD,FRUIT,ERR = 666)	!Read who knows what.
  666     CLOSE (FIELD)			!Ignoring any misformats.
        END SUBROUTINE GETVALS	!A proper routine would offer error messages.

        SUBROUTINE PUTVALS(FNAME)	!Writes values to some file.
         CHARACTER*(*) FNAME	!The file name.
         NAMELIST /FRUIT/ FAVOURITEFRUIT,NEEDSPEELING,NUMBEROFBANANAS
          OPEN(FIELD,FILE=FNAME,STATUS="REPLACE",ACTION="WRITE",	!Prepare a recipient file.
     1     DELIM="QUOTE")	!CHARACTER variables will be enquoted.
          WRITE (FIELD,FRUIT)	!Write however much is needed.
          CLOSE (FIELD)		!Finished for now.
        END SUBROUTINE PUTVALS
      END MODULE MONKEYFODDER

      PROGRAM TEST	!Updates the file created by an earlier version.
      USE MONKEYFODDER
      FIELD = 10	!This will do.
      CALL GETVALS("Basket.txt")	!Read the values, allowing for the previous version.
      CALL PUTVALS("Basket.txt")	!Save the values, as per the new version.
      END
