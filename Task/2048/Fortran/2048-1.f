        WRITE (MSG,1)		!Roll forth a top/bottom boundary. No corner characters (etc.), damnit.
    1   FORMAT ("|",<NC>(<W>("-"),"|"))	!Heavy reliance on runtime values in NC and W. But see FORMAT 22.
    2     FORMAT ("|",<NC>(<W>(" "),"|"))	!No horizontal markings within a tile. See FORMAT 1.
          WRITE (MSG,22) ((" ",L1  = 1,W),"|",C = 1,NC)	!Compare to FORMAT 2.
   22     FORMAT ("|",666A1)				!A constant FORMAT, a tricky WRITE.
    4     FORMAT ("|",<NC - 1>(<W>("-"),"+"),<W>("-"),"|")	!With internal + rather than |.
