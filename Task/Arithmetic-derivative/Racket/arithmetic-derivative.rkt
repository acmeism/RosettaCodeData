#lang racket/base

(require
  math/number-theory
  racket/contract/base
  racket/match)

(provide
  (contract-out
   [δ (-> rational? rational?)]))

(define (∂ N)
  (let ([|N| (inexact->exact (abs N))])
    (for/sum ([power (in-list (factorize |N|))])
      (match-define (list prime expt) power)
      (/ expt prime))))

(define (δ m/n)
  (define m (numerator   m/n))
  (define n (denominator m/n))
  (cond
    [(= 1 n) (* m (∂ m))]
    [else
     (/ (- (* n (δ m)) (* m (δ n)))
        (* n n))]))

(module+ test
  (require
    racket/format
    racket/string)

  (define (align-number n width)
    (~a n #:min-width width #:align 'right))

  (displayln "task: show arithmetic derivatives of the integers -99..100")
  (define cols (build-list 10 add1))
  (for ([row (in-inclusive-range -10 9)])
    (displayln
     (string-join
      (map (lambda (col) (align-number (δ (+ (* 10 row) col)) 5))
           cols)
      " │ ")))
  (newline)

  (displayln "stretch task: show arithmetic derivatives of 10^m / 7 for m=1..20")
  (for ([n (in-inclusive-range 1 20)])
    (displayln
     (format "D(10^~a) / 7 = ~a" (align-number n 2) (/ (δ (expt 10 n)) 7)))))
