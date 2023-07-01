(catch NIL
   (for Lst (make (do 10 (link (make (do 10 (link (rand 1 20)))))))
      (for N Lst
         (printsp N)
         (and (= N 20) (throw)) ) ) )
