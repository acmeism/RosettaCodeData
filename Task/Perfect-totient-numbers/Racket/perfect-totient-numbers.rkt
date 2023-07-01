#lang racket
(require math/number-theory)

(define (tot n)
  (match n
    [1 0]
    [n (define t (totient n))
       (+ t (tot t))]))

(define (perfect? n)
  (= n (tot n)))

(define-values (ns i)
  (for/fold ([ns '()] [i 0])
            ([n (in-naturals 1)]
             #:break (= i 20)
             #:when (perfect? n))
    (values (cons n ns) (+ i 1))))

(reverse ns)
