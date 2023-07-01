      SUBROUTINE STARTS(A,B)	!Text A starts with text B?
       CHARACTER*(*) A,B
        IF (INDEX(A,B).EQ.1) THEN	!Searches A to find B.
          WRITE (6,*) ">",A,"< starts with >",B,"<"
         ELSE
          WRITE (6,*) ">",A,"< does not start with >",B,"<"
        END IF
      END SUBROUTINE STARTS

      SUBROUTINE HAS(A,B)	!Text B appears somewhere in text A?
       CHARACTER*(*) A,B
       INTEGER L
        L = INDEX(A,B)		!The first position in A where B matches.
        IF (L.LE.0) THEN
          WRITE (6,*) ">",A,"< does not contain >",B,"<"
         ELSE
          WRITE (6,*) ">",A,"< contains a >",B,"<, offset",L
        END IF
      END SUBROUTINE HAS

      SUBROUTINE ENDS(A,B)	!Text A ends with text B.
       CHARACTER*(*) A,B
       INTEGER L
        L = LEN(A) - LEN(B)	!Find the tail end of A that B might match.
        IF (L.LT.0) THEN	!Dare not use an OR, because of full evaluation risks.
          WRITE (6,*) ">",A,"< is too short to end with >",B,"<"	!Might as well have a special message.
        ELSE IF (A(L + 1:L + LEN(B)).NE.B) THEN	!Otherwise, it is safe to look.
          WRITE (6,*) ">",A,"< does not end with >",B,"<"
        ELSE
          WRITE (6,*) ">",A,"< ends with >",B,"<"
        END IF
      END SUBROUTINE ENDS

      CALL STARTS("This","is")
      CALL STARTS("Theory","The")
      CALL HAS("Bananas","an")
      CALL ENDS("Banana","an")
      CALL ENDS("Banana","na")
      CALL ENDS("Brief","Much longer")
      END
