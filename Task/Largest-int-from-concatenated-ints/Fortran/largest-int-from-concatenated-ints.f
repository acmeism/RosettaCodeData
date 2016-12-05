      SUBROUTINE SWAP(A,B)	!Why can't the compiler supply these!
       INTEGER A,B,T
        T = B
        B = A
        A = T
      END

      SUBROUTINE BIGUP(TEXT,N)	!Outputs the numbers in TEXT to give the biggest number.
       CHARACTER*(*) TEXT(*)	!The numbers as text, aligned left.
       INTEGER N		!The number of them.
       INTEGER XLAT(N),L(N)	!An index and a set of lengths.
       INTEGER I,J,M		!Assorted steppers.
       INTEGER TI,TJ		!Fingers to a text.
       INTEGER LI,LJ		!Lengths of the fingered texts.
       INTEGER MSG		!I/O unit number.
       COMMON /IODEV/ MSG	!Old style.
        DO I = 1,N	!Step through my supply of texts.
          XLAT(I) = I		!Preparing a finger to them.
          L(I) = LEN_TRIM(TEXT(I))	!And noting their last non-blank.
        END DO		!On to the next.
        WRITE (MSG,1) "Supplied",(TEXT(I)(1:L(I)), I = 1,N)	!Show the grist.
    1   FORMAT (A12,":",<N>(A,","))	!Instead of <N>, 666 might suffice.
Crude bubblesort. No attempt at noting the bounds of swaps made.
        DO M = N,1,-1	!Just for fun, go backwards.
          DO I = 2,M		!Start a scan.
            J = I - 1		!Comparing element I to element I - 1.
            TI = XLAT(I)	!Thus finger the I'th text in XLAT order.
            TJ = XLAT(J)	!And its supposed predecessor.
            LI = L(TI)		!The length of the fingered text.
            LJ = L(TJ)		!All this to save on typing below.
            IF (LI .EQ. LJ) THEN	!If the texts are equal lengths,
              IF (TEXT(TI).LT.TEXT(TJ)) CALL SWAP(XLAT(I),XLAT(J))	!A simple comparison.
             ELSE	!But if not, construct the actual candidate texts for comparison.
              IF (TEXT(TI)(1:LI)//TEXT(TJ)(1:LJ)	!These two will be the same length.
     1        .LT.TEXT(TJ)(1:LJ)//TEXT(TI)(1:LI))	!Just as above.
     2        CALL SWAP(XLAT(I),XLAT(J))	!J shall now follow I.
            END IF			!So much for that comparison.
          END DO		!On to the next.
        END DO	!The original plan was to reveal element XLAT(M) as found.
        WRITE (MSG,2) "Biggest",(TEXT(XLAT(I))(1:L(XLAT(I))),I = N,1,-1)	!But, all at once is good too.
    2   FORMAT (A12,":",<N>(A," "))	!The space maintains identity.
      END	!That was fun.

      PROGRAM POKE
      CHARACTER*4 T1(10)	!Prepare some example arrays.
      CHARACTER*4 T2(4)		!To hold the specified examples.
      INTEGER MSG
      COMMON /IODEV/ MSG
      DATA T1(1:8)/"1","34","3","98","9","76","45","4"/
      DATA T2/"54","546","548","60"/
      MSG = 6		!Standard output.
      WRITE (MSG,1)
    1 FORMAT ("Takes a list of integers and concatenates them so as ",
     1 "to produce the biggest possible number.",/,
     2 "The result is shown with spaces between the parts ",
     3 "to show provenance. Ignore them otherwise."/)
      CALL BIGUP(T1,8)

      WRITE (MSG,*)
      CALL BIGUP(T2,4)

      WRITE (MSG,*) "These are supplied in lexicographical order..."
      CALL BIGUP((/"5","54"/),2)

      WRITE (MSG,*) "But this is not necessarily the biggest order."
      CALL BIGUP((/"5","56"/),2)

      WRITE (MSG,*) "And for those who count..."
      DO I = 1,10
        WRITE (T1(I),"(I0)") I	!This format code produces only the necessary text.
      END DO			!Thus, the numbers are aligned left in the text field.
      CALL BIGUP(T1,10)
      END
