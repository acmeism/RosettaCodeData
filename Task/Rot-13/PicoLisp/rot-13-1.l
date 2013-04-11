(de rot13-Ch (C)
   (if
      (or
         (member C '`(apply circ (chop "ABCDEFGHIJKLMNOPQRSTUVWXYZ")))
         (member C '`(apply circ (chop "abcdefghijklmnopqrstuvwxyz"))) )
      (get @ 14)
      C ) )
