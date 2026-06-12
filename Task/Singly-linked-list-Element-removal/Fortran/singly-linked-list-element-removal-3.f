      IT = 0		!This list element fingers the start of the list..
      DO WHILE((NEXT = LINK(IT)).GT.0)	!Finger the follower of IT.
        IF (NEXT.EQ.X) THEN		!Is it the unwanted one?
          LINK(IT) = LINK(NEXT)			!Yes! Step over it!
          RETURN				!Done. Escape!
        END IF				!But if not,
        IT = NEXT			!Advance to the follower.
      END DO				!Ends when node IT's follower is null.
