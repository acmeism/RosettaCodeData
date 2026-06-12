          IT = 0		!This list element fingers the start of the list..
    1     NEXT = LINK(IT)	!This is the node of interest.
          IF (NEXT.GT.0) THEN	!Is it a live node?
            IF (NEXT.EQ.X) THEN		!Yes. Is it the unwanted one?
              LINK(IT) = LINK(NEXT)		!Yes! Step over it!
              RETURN				!Done. Escape!
            END IF			!But if the follower survives,
            IT = NEXT			!Advance to finger it.
            GO TO 1			!And try afresh.
          END IF		!So much for that node.
