(lib 'list) ;; in-permutations
(lib 'bigint)

;; generates derangements by filtering out permutations
(define (derangement? nums) ;; predicate
    (for/and ((n nums) (i (length nums))) (!= n i)))

(define (derangements n)
    (for/list ((p (in-permutations n))) #:when (derangement? p) p))

(define (count-derangements n)
    (for/sum ((p (in-permutations n))) #:when (derangement? p) 1))

;;
;;  !n = (n - 1) (!(n-1) + !(n-2))

(define (!n n)
	(* (1- n) (+ (!n (1- n)) (!n (- n 2)))))
(remember '!n #(1 0))
