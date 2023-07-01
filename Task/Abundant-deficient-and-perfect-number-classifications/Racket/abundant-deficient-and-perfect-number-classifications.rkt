#lang racket
(require math)
(define (proper-divisors n) (drop-right (divisors n) 1))
(define classes '(deficient perfect abundant))
(define (classify n)
  (list-ref classes (add1 (sgn (- (apply + (proper-divisors n)) n)))))

(let ([N 20000])
  (define t (make-hasheq))
  (for ([i (in-range 1 (add1 N))])
    (define c (classify i))
    (hash-set! t c (add1 (hash-ref t c 0))))
  (printf "The range between 1 and ~a has:\n" N)
  (for ([c classes]) (printf "  ~a ~a numbers\n" (hash-ref t c 0) c)))
