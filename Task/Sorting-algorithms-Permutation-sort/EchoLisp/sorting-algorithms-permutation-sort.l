;; This efficient sort method uses the list library for permutations

(lib 'list)
(define (in-order L)
(cond
    ((empty? L) #t)
    ((empty? (rest L)) #t)
    (else (and ( < (first L) (second  L)) (in-order (rest L))))))

(define L (shuffle (iota 6)))
    → (1 5 4 2 0 3)

(for ((p (in-permutations (length L ))))
    #:when (in-order (list-permute L p))
       (writeln (list-permute L p)) #:break #t)

    → (0 1 2 3 4 5)
