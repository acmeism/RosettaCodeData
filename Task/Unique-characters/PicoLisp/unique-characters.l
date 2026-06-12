(de uni (Lst
   (let R NIL
      (mapc
         '((L)
            (mapc
               '((L) (accu 'R L 1)) L ) )
         (mapcar chop Lst) )
      (mapcar
         car
         (by
            car
            sort
            (filter '((L) (=1 (cdr L))) R) ) ) ) )
(println
   (uni
      (quote
         "133252abcdeeffd"
         "a6789798st"
         "yxcdfgxcyz" ) ) )
