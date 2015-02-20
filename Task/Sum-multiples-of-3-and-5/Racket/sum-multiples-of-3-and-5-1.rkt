#lang racket
(require math)

;;; A naive solution
(define (naive k)
  (for/sum ([n (expt 10 k)]
            #:when (or (divides? 3 n) (divides? 5 n)))
    n))

(for/list ([k 7]) (naive k))


;;; Using the formula for an arithmetic sum
(define (arithmetic-sum a1 n Δa)
  ; returns a1+a2+...+an
  (define an (+ a1 (* (- n 1) Δa)))
  (/ (* n (+ a1 an)) 2))

(define (analytical k)
  (define 10^k (expt 10 k))
  (define (n d) (quotient (- 10^k 1) d))
  (+    (arithmetic-sum  3 (n  3)  3)
        (arithmetic-sum  5 (n  5)  5)
     (- (arithmetic-sum 15 (n 15) 15))))

(for/list ([k 20]) (analytical k))
