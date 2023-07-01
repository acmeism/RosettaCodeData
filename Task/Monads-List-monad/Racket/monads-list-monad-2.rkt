#lang racket

(require data/monad
         data/applicative)

(define (pythagorean-triples n)
  (sequence->list
   (do [x <- (range 1 n)]
       [y <- (range (add1 x) n)]
       [z <- (range (add1 y) n)]
       (if (= (+ (* x x) (* y y)) (* z z))
           (pure (list x y z))
           '()))))

(pythagorean-triples 25)
;; => '((3 4 5) (5 12 13) (6 8 10) (8 15 17) (9 12 15) (12 16 20))
