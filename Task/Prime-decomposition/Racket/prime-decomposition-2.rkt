#lang racket
(define (factors number)
  (let loop ([n number] [i 2])
    (if (= n 1)
      '()
      (let-values ([(q r) (quotient/remainder n i)])
        (if (zero? r) (cons i (loop q i)) (loop n (add1 i)))))))
