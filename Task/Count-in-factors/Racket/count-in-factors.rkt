#lang typed/racket

(require math/number-theory)

(define (factorise-as-primes [n : Natural])
  (if
   (= n 1)
   '(1)
   (let ((F (factorize n)))
     (append*
      (for/list : (Listof (Listof Natural))
        ((f (in-list F)))
        (make-list (second f) (first f)))))))

(define (factor-count [start-inc : Natural] [end-inc : Natural])
  (for ((i : Natural (in-range start-inc (add1 end-inc))))
    (define f (string-join (map number->string (factorise-as-primes i)) " × "))
    (printf "~a:\t~a~%" i f)))

(factor-count 1 22)
(factor-count 2140 2150)
; tb
