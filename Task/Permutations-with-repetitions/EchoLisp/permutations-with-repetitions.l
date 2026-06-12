(lib 'sequences) ;; (indices   ..)
(lib 'list) ;; (list-permute ..)

;; (indices range_1 ..range_k) returns a  procrastinator (lazy sequence)
;; which gives all combinations of indices_i in range_i.
;;
;; If  all  k ranges are equal to (0 ...n-1)
;; (indices (make-vector k n))
;; will give the n^k permutations with repetitions of the integers (0 ... n-1).


(define perms (indices (make-vector 2 3)))
(take perms #:all)
    → (#(0 0) #(0 1) #(0 2) #(1 0) #(1 1) #(1 2) #(2 0) #(2 1) #(2 2))
(length perms) → 9

;; 6-permute the numbers (0 ....9)
(define perms (indices (make-vector 6 10)))
(length perms) → 1000000

;; passing the procrastinator to a routine
;; which stops when sum = 22
(for ((p perms))
    #:break (= (apply + (vector->list p)) 22) => p )
     →  #( 0 0 0 4 9 9)

;; to permute any objects, use (list-permute list permutation-vector/list)
(list-permute '(a b c d e) '(1 0 1 0 3 2 1))
    → (b a b a d c b)
(list-permute '(a b c d e) #(1 0 1 0 3 2 1))
    → (b a b a d c b)
