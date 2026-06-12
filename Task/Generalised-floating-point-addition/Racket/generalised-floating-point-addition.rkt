#lang racket
(define (f n (printf printf))
  (define exponent (* (- n) 9))
  (define mantissa
    (for/fold ((m 0))
              ((i (in-range -7 (add1 n))))
      (+ (* m 1000000000) 12345679)))

  (let ((rv (+ (expt 10 exponent) (* mantissa (expt 10 exponent) 81))))
    (printf "~ae~a * 81 + 1e~a - 1e72 = ~a~%"
            (~.a mantissa
                 #:max-width 20
                 #:limit-marker (format "..[~a].." (add1 (order-of-magnitude mantissa))))
            exponent
            exponent
            (- #e1e72 rv))
    rv))

(module+ test
  (require rackunit)
  (check-equal? (f -7 void) (expt 10 72))
  (check-equal? (f -6 void) (expt 10 72)))

(module+ main
  (displayln "number in brackets is TOTAL number of digits")
  (for ((i (in-range -7 (add1 21)))) (f i)))
