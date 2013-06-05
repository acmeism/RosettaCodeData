#lang racket
(require math/number-theory)
(define (digital-sum n)
  (let inner
    ((n n) (s 0))
    (if (zero? n) s
        (let-values ([(q r) (quotient/remainder n 10)])
          (inner q (+ s r))))))

(define (harshad-number? n)
  (and (>= n 1)
       (divides? (digital-sum n) n)))

;; find 1st 20 Harshad numbers
(for ((i (in-range 1 (add1 20)))
      (h (sequence-filter harshad-number? (in-naturals 1))))
  (printf "#~a ~a~%" i h))

;; find 1st Harshad number > 1000
(displayln (for/first ((h (sequence-filter harshad-number? (in-naturals 1001)))) h))
