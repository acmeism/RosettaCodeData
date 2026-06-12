      MODULE SIMPLELINKEDLIST	!Play with an array. Other arrays might hold content.
       CONTAINS			!Demonstration only!
        SUBROUTINE LLREMOVE(LINK,X)	!Remove entry X from the links in LINK.
         INTEGER LINK(0:)	!The links.
         INTEGER X		!The "address" or index, of the unwanted one.
         INTEGER IT		!A stepper.
          IT = 0		!This list element fingers the start of the list..
          DO WHILE(LINK(IT).GT.0)	!While a live follower,
            IF (LINK(IT).EQ.X) THEN		!Is that follower unwanted?
              LINK(IT) = LINK(LINK(IT))		!Yes! Step over it!
              RETURN				!Done. Escape!
            END IF			!But if the follower survives,
            IT = LINK(IT)		!Advance to finger it.
          END DO		!And try afresh.
        END SUBROUTINE LLREMOVE	!No checks for infinite loops!

        SUBROUTINE LLFOLLOW(LINK)	!Show the sequence.
         INTEGER LINK(0:)	!The links.
          IT = 0			!Start by fingering the head.
          WRITE (6,1) "Head",IT,LINK(IT)	!Show it.
    1     FORMAT (A6,I3," -->",I3)		!This will do.
    2     IT = LINK(IT)		!Advance.
          IF (IT.LE.0) RETURN		!Done yet?
          WRITE (6,1) "at",IT,LINK(IT)	!Nope. Show.
          GO TO 2			!And try afresh.
        END SUBROUTINE LLFOLLOW	!No checks for infinite loops!
      END MODULE SIMPLELINKEDLIST	!A bit trickier with bidirectional links.

      PROGRAM POKE
      USE SIMPLELINKEDLIST	!Just so.
      INTEGER LINK(0:5)		!This will suffice.
      DATA LINK/3, 2,4,1,5,0/	!Set the head and its followers.

      WRITE (6,*) "A linked-list, no cargo."
      CALL LLFOLLOW(LINK)

      WRITE (6,*) "The element at one suffers disfavour."
      CALL LLREMOVE(LINK,1)
      CALL LLFOLLOW(LINK)

      WRITE (6,*) "Off with the head!"
      CALL LLREMOVE(LINK,LINK(0))	!LINK(0) fingers the head element.
      CALL LLFOLLOW(LINK)

      WRITE (6,*) "And off with the tail."
      CALL LLREMOVE(LINK,5)		!The tail element is not tracked.
      CALL LLFOLLOW(LINK)		!But, I know where it was, in this example.

      END
