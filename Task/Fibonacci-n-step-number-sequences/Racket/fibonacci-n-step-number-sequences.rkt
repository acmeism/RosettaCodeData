#lang racket

;; fib-list : [Listof Nat] x Nat -> [Listof Nat]
;; Given a non-empty list of natural numbers, the length of the list
;; becomes the size of the step; return the first n numbers of the
;; sequence; assume n >= (length lon)
(define (fib-list lon n)
  (define len (length lon))
  (reverse (for/fold ([lon (reverse lon)]) ([_ (in-range (- n len))])
             (cons (apply + (take lon len)) lon))))

;; Show the series ...
(define (show-fibs name l)
  (printf "~a: " name)
  (for ([n (in-list (fib-list l 20))]) (printf "~a, " n))
  (printf "...\n"))

;; ... with initial 2-powers lists
(for ([n (in-range 2 11)])
  (show-fibs (format "~anacci" (case n [(2) 'fibo] [(3) 'tribo] [(4) 'tetra]
                                     [(5) 'penta] [(6) 'hexa] [(7) 'hepta]
                                     [(8) 'octo] [(9) 'nona] [(10) 'deca]))
             (cons 1 (build-list (sub1 n) (curry expt 2)))))
;; and with an initial (2 1)
(show-fibs "lucas" '(2 1))
