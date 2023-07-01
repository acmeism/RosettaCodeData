      CHARACTER*1 FUNCTION CUSIPCHECK(TEXT)	!Determines the check sum character.
Committee on Uniform Security Identification Purposes, of the American (i.e. USA) Bankers' Association.
       CHARACTER*8 TEXT		!Specifically, an eight-symbol code.
       CHARACTER*(*) VALID	!These only are valid.
       PARAMETER (VALID = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*@#")
       INTEGER I,V,S		!Assistants.
        S = 0		!Start the checksum.
        DO I = 1,LEN(TEXT)	!Step through the text.
          V = INDEX(VALID,TEXT(I:I)) - 1	!Since counting starts with one.
          IF (MOD(I,2).EQ.0) V = V*2		!V = V*(2 - MOD(I,2))?
          S = S + V/10 + MOD(V,10)		!Specified calculation.
        END DO			!On to the next character.
        I = MOD(10 - MOD(S,10),10) + 1	!Again, counting starts with one.
        CUSIPCHECK = VALID(I:I)	!Thanks to the MOD 10, surely a digit.
      END FUNCTION CUSIPCHECK	!No checking for invalid input...

      PROGRAM POKE	!Just to try it out.
      INTEGER I,N	!Assistants.
      PARAMETER (N = 6)		!A whole lot of blather
      CHARACTER*9 CUSIP(N)	!Just to have an array of test codes.
      DATA CUSIP/		!Here they are, as specified.
     1  "037833100",
     2  "17275R102",
     3  "38259P508",
     4  "594918104",
     5  "68389X106",
     6  "68389X105"/
      CHARACTER*1 CUSIPCHECK	!Needed as no use of the MODULE protocol.

      DO I = 1,N	!"More than two? Use a DO..."
        WRITE (6,*) CUSIP(I),CUSIPCHECK(CUSIP(I)(1:8)).EQ.CUSIP(I)(9:9)
      END DO

      END
