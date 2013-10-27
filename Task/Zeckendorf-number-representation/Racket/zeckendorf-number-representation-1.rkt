#lang racket (require math)

(define (fibs n)
  (reverse
   (for/list ([i (in-naturals 2)] #:break (> (fibonacci i) n))
     (fibonacci i))))

(define (zechendorf n)
  (match/values
   (for/fold ([n n] [xs '()]) ([f (fibs n)])
     (if (> f n)
         (values n       (cons 0 xs))
         (values (- n f) (cons 1 xs))))
   [(_ xs) (reverse xs)]))

(for/list ([n 21])
  (list n (zechendorf n)))
