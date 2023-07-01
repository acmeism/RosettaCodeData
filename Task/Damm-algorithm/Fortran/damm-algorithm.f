      LOGICAL FUNCTION DAMM(DIGIT)	!Check that a sequence of digits checks out..
Calculates according to the method of H. Michael Damm, described in 2004.
       CHARACTER*(*) DIGIT		!A sequence of digits only.
       INTEGER*1 OPTABLE(0:9,0:9)	!The special "Operation table" of the method.
       PARAMETER (OPTABLE = (/		!A set of constants...
     o  0, 3, 1, 7, 5, 9, 8, 6, 4, 2,	!        CAREFUL!
     1  7, 0, 9, 2, 1, 5, 4, 8, 6, 3,	!Fortran stores arrays in column-major order.
     2  4, 2, 0, 6, 8, 7, 1, 3, 5, 9,	!Despite the manifest row and column layout apparent here
     3  1, 7, 5, 0, 9, 8, 3, 4, 2, 6,	!This sequence of consecutive items will go into storage order.
     4  6, 1, 2, 3, 0, 4, 5, 9, 7, 8,	!The table resulting from this sequence of constants
     5  3, 6, 7, 4, 2, 0, 9, 5, 8, 1,	!Will appear to be transposed if referenced as (row,column)
     6  5, 8, 6, 9, 7, 2, 0, 1, 3, 4,	!What appears to be row=6 column=1 (counting from zero)
     7  8, 9, 4, 5, 3, 6, 2, 0, 1, 7,	!is to be accessed as OPTABLE(1,6) = 8, not OPTABLE(6,1)
     8  9, 4, 3, 8, 6, 1, 7, 2, 0, 5,	!Storage order is (0,0), (1,0), (2,0), ... (9,0)
     9  2, 5, 8, 1, 4, 3, 6, 7, 9, 0/))	!Followed by      (0,1), (1,1), (2,1), ... (9,1)
       INTEGER I,D,ID	!Assistants.
        ID = 0		!Here we go.
        DO I = 1,LEN(DIGIT)	!Step through the text.
          D = ICHAR(DIGIT(I:I)) - ICHAR("0")	!Convert to an integer. (ASCII or EBCDIC)
          IF (D.LT.0 .OR. D.GT.9) STOP "DAMM! Not a digit!"	!This shouldn't happen!
          ID = OPTABLE(D,ID)		!Transposed: D is the column index and ID the row.
        END DO			!On to the next.
        DAMM = ID .EQ. 0	!Somewhere, a check digit should ensure this.
      END FUNCTION DAMM	!Simple, fast, and alas, rarely used.

      LOGICAL DAMM	!Not a default type.

      WRITE (6,*) DAMM("5724"),"5724"
      WRITE (6,*) DAMM("5727"),"5727"
      WRITE (6,*) DAMM("112946"),"112946"

      END
