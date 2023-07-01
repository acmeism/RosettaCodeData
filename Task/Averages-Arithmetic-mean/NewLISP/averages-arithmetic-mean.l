(define (Mean Lst)
   (if (empty? Lst)
      0
      (/ (apply + Lst) (length Lst))))

 (Mean (sequence 1 1000))-> 500
 (Mean '()) -> 0
