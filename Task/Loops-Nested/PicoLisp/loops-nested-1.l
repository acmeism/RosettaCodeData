(for Lst (make (do 10 (link (make (do 10 (link (rand 1 20)))))))
   (T
      (for N Lst
         (printsp N)
         (T (= N 20) T) ) ) )
