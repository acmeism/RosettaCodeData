(de orderDisjoint (M N)
   (for S N
      (and (memq S M) (set @ NIL)) )
   (mapcar
      '((S) (or S (pop 'N)))
      M ) )
