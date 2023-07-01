(de bogosort (Lst)
   (loop
      (map
         '((L) (rot L (rand 1 (length L))))
         Lst )
      (T (apply <= Lst) Lst) ) )
