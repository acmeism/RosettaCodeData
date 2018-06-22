   20     READ (INF,21, END = 30) L	!R E A D  A  R E C O R D - but only its length.
   21     FORMAT(Q)			!This obviously indicates the record's length.
          NRECS = NRECS + 1	!CALL LONGCOUNT(NRECS,1)	!C O U N T  A  R E C O R D.
          NNBYTES = NNBYTES + L	!CALL LONGCOUNT(NNBYTES,L)	!Not counting any CRLF (or whatever) gibberish.
          IF (L.LT.RMIN) THEN		!Righto, now for the record lengths.
            RMIN = L			!This one is shorter.
            RMINR = NRECS		!Where it's at.
          ELSE IF (L.GT.RMAX) THEN	!Perhaps instead it is longer?
            RMAX = L			!Longer.
            RMAXR = NRECS		!Where it's at.
          END IF			!So much for the lengths.
          GO TO 20			!All I wanted to know...
