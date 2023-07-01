      MODULE SORTSEARCH		!Genuflect towards Prof. D. Knuth.

       INTERFACE FIND			!Binary chop search, not indexed.
        MODULE PROCEDURE
     1   FINDI4,				!I: of integers.
     2   FINDF4,FINDF8,				!F: of numbers.
     3          FINDTTI2,FINDTTI4		!T: of texts.
       END INTERFACE FIND

      CONTAINS
      INTEGER FUNCTION FINDI4(THIS,NUMB,N)	!Binary chopper. Find i such that THIS = NUMB(i)
       USE ASSISTANCE		!Only for the trace stuff.
       INTENT(IN) THIS,NUMB,N	!Imply read-only, but definitely no need for any "copy-back".
       INTEGER*4 THIS,NUMB(1:*)	!Where is THIS in array NUMB(1:N)?
       INTEGER N		!The count. In other versions, it is supplied by the index.
       INTEGER L,R,P		!Fingers.
Chop away.
        L = 0			!Establish outer bounds.
        R = N + 1		!One before, and one after, the first and last.
    1   P = (R - L)/2		!Probe point offset. Beware integer overflow with (L + R)/2.
        IF (P.LE.0) THEN	!Aha! Nowhere! And THIS follows NUMB(L).
          FINDI4 = -L		!Having -L rather than 0 (or other code) might be of interest.
          RETURN		!Finished.
        END IF			!So much for exhaustion.
        P = P + L		!Convert from offset to probe point.
        IF (THIS - NUMB(P)) 3,4,2	!Compare to the probe point.
    2   L = P			!Shift the left bound up: THIS follows NUMB(P).
        GO TO 1			!Another chop.
    3   R = P			!Shift the right bound down: THIS precedes NUMB(P).
        GO TO 1			!Try again.
Caught it! THIS = NUMB(P)
    4   FINDI4 = P		!So, THIS is found, here!
      END FUNCTION FINDI4	!On success, THIS = NUMB(FINDI4); no fancy index here...

      END MODULE SORTSEARCH
