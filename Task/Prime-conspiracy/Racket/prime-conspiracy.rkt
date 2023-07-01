#lang racket

(require math/number-theory)

(define limit 1000000)

(define table
  (for/fold ([table (hash)] [prev 2] #:result table)
            ([p (in-list (next-primes 2 (sub1 limit)))])
    (define p-mod (modulo p 10))
    (values (hash-update table (cons prev p-mod) add1 0) p-mod)))

(define (pair<? p q) (or (< (car p) (car q)) (and (= (car p) (car q)) (< (cdr p) (cdr q)))))

(printf "~a first primes. Transitions prime % 10 → next-prime % 10.\n" limit)
(for ([item (sort (hash->list table) pair<? #:key car)])
  (match-define (cons (cons x y) freq) item)
  (printf "~a → ~a count: ~a frequency: ~a %\n"
          x y (~a freq #:min-width 8 #:align 'right) (~r (* 100 freq (/ 1 limit)) #:precision '(= 2))))
