#lang racket
(define (van-der-Corput n base)
  (if (zero? n)
      0
      (let-values ([(q r) (quotient/remainder n base)])
        (/ (+ r (van-der-Corput q base))
           base))))
