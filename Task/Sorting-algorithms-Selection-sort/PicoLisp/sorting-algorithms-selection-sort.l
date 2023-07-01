(de selectionSort (Lst)
   (map
      '((L) (and (cdr L) (xchg L (member (apply min @) L))))
      Lst )
   Lst )
