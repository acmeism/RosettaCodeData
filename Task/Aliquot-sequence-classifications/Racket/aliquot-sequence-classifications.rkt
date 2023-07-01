#lang racket
(require "proper-divisors.rkt" math/number-theory)

(define SCOPE 20000)

(define P
  (let ((P-v (vector)))
    (λ (n)
      (cond
        [(> n SCOPE)
         (apply + (drop-right (divisors n) 1))]
        [else
         (set! P-v (fold-divisors P-v n 0 +))
         (vector-ref P-v n)]))))

;; initialise P-v
(void (P SCOPE))

(define (aliquot-sequence-class K)
  ;; note that seq is reversed as a list, since we're consing
  (define (inr-asc seq)
    (match seq
      [(list 0 _ ...)
       (values "terminating" seq)]
      [(list (== K) (== K) _ ...)
       (values "perfect" seq)]
      [(list n n _ ...)
       (values (format "aspiring to ~a" n) seq)]
      [(list (== K) ami (== K) _ ...)
       (values (format "amicable with ~a" ami) seq)]
      [(list (== K) cycle ... (== K))
       (values (format "sociable length ~a" (add1 (length cycle))) seq)]
      [(list n cycle ... n _ ...)
       (values (format "cyclic on ~a length ~a" n (add1 (length cycle))) seq)]
      [(list X _ ...)
       #:when (> X 140737488355328)
       (values "non-terminating big number" seq)]
      [(list seq ...)
       #:when (> (length seq) 16)
       (values "non-terminating long sequence" seq)]
      [(list seq1 seq ...) (inr-asc (list* (P seq1) seq1 seq))]))
(inr-asc (list K)))

(define (report-aliquot-sequence-class n)
  (define-values (c s) (aliquot-sequence-class n))
  (printf "~a:\t~a\t~a~%" n c (reverse s)))

(for ((i (in-range 1 10)))
  (report-aliquot-sequence-class i))
(newline)

(for ((i (in-list '(11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488 15355717786080))))
  (report-aliquot-sequence-class i))
