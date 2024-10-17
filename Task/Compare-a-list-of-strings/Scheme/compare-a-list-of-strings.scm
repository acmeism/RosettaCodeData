(define (compare-strings fn strs)
  (or (null? strs)                             ; returns #t on empty list
      (null? (cdr strs))                       ; returns #t on list of size 1
      (do ((fst strs (cdr fst))
           (snd (cdr strs) (cdr snd)))
        ((or (null? snd)
             (not (fn (car fst) (car snd))))
         (null? snd)))))                       ; returns #t if the snd list is empty, meaning all comparisons are exhausted

(compare-strings string=? strings) ; test for all equal
(compare-strings string<? strings) ; test for in ascending order
