      SUBROUTINE CSVTEXT2HTML(FNAME,HEADED)	!Does not recognise quoted strings.
Converts without checking field counts, or noting special characters.
       CHARACTER*(*) FNAME	!Names the input file.
       LOGICAL HEADED		!Perhaps its first line is to be a heading.
       INTEGER MANY		!How long is a piece of string?
       PARAMETER (MANY=666)	!This should suffice.
       CHARACTER*(MANY) ALINE	!A scratchpad for the input.
       INTEGER MARK(0:MANY + 1)	!Fingers the commas on a line.
       INTEGER I,L,N		!Assistants.
       CHARACTER*2 WOT(2)	!I don't see why a "table datum" could not be for either.
       PARAMETER (WOT = (/"th","td"/))	!A table heding or a table datum
       INTEGER IT		!But, one must select appropriately.
       INTEGER KBD,MSG,IN		!A selection.
       COMMON /IOUNITS/ KBD,MSG,IN	!The caller thus avoids collisions.
        OPEN(IN,FILE=FNAME,STATUS="OLD",ACTION="READ",ERR=661)	!Go for the file.
        WRITE (MSG,1)			!Start the blather.
    1   FORMAT ("<Table border=1>")	!By stating that a table follows.
        MARK(0) = 0		!Syncopation for the comma fingers.
        N = 0			!No records read.

   10   READ (IN,11,END = 20) L,ALINE(1:MIN(L,MANY))	!Carefully acquire some text.
   11   FORMAT (Q,A)		!Q = number of characters yet to read, A = characters.
        N = N + 1		!So, a record has been read.
        IF (L.GT.MANY) THEN	!Perhaps it is rather long?
          WRITE (MSG,12) N,L,MANY	!Alas!
   12     FORMAT ("Line ",I0," has length ",I0,"! My limit is ",I0)	!Squawk/
          L = MANY			!The limit actually read.
        END IF			!So much for paranoia.
        IF (N.EQ.1 .AND. HEADED) THEN	!Is the first line to be treated specially?
          WRITE (MSG,*) "<tHead>"	!Yep. Nominate a heading.
          IT = 1			!And select "th" rather than "td".
         ELSE				!But mostly,
          IT = 2			!Just another row for the table.
        END IF			!So much for the first line.
        NCOLS = 0		!No commas have been seen.
        DO I = 1,L		!So scan the text for them.
          IF (ICHAR(ALINE(I:I)).EQ.ICHAR(",")) THEN	!Here?
            NCOLS = NCOLS + 1		!Yes!
            MARK(NCOLS) = I		!The texts are between commas.
          END IF			!So much for that character.
        END DO			!On to the next.
        NCOLS = NCOLS + 1	!This is why the + 1 for the size of MARK.
        MARK(NCOLS) = L + 1	!End-of-line is as if a comma was one further along.
        WRITE (MSG,13)		!Now roll all the texts.
     1   (WOT(IT),				!This starting a cell,
     2    ALINE(MARK(I - 1) + 1:MARK(I) - 1),	!This being the text between the commas,
     3    WOT(IT),				!And this ending each cell.
     4    I = 1,NCOLS),			!For this number of columns.
     5   "/tr"			!And this ends the row.
   13   FORMAT (" <tr>",666("<",A,">",A,"</",A,">"))	!How long is a piece of string?
        IF (N.EQ.1 .AND. HEADED) WRITE (MSG,*) "</tHead>"	!Finish the possible header.
        GO TO 10		!And try for another record.

   20   CLOSE (IN)		!Finished with input.
        WRITE (MSG,21)		!And finished with output.
   21   FORMAT ("</Table>")	!This writes starting at column one.
       RETURN			!Done!
Confusions.
  661   WRITE (MSG,*) "Can't open file ",FNAME	!Alas.
      END			!So much for the conversion.

      INTEGER KBD,MSG,IN
      COMMON /IOUNITS/ KBD,MSG,IN
      KBD = 5	!Standard input.
      MSG = 6	!Standard output.
      IN = 10	!Some unspecial number.

      CALL CSVTEXT2HTML("Text.csv",.FALSE.)	!The first line is not special.
      WRITE (MSG,*)
      CALL CSVTEXT2HTML("Text.csv",.TRUE.)	!The first line is a heading.
      END
