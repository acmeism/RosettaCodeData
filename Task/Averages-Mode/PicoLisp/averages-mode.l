(de modes (Lst)
   (let A NIL
      (for X Lst
         (accu 'A X 1) )
      (mapcar car
         (maxi cdar
            (by cdr group A) ) ) ) )
