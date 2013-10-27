#lang typed/racket

(: make-recursive : (All (S T) ((S -> T) -> (S -> T)) -> (S -> T)))
(define-type Tau (All (S T) (Rec this (this -> (S -> T)))))
(define (make-recursive f)
  ((lambda: ([x : (Tau S T)]) (f (lambda (z) ((x x) z))))
   (lambda: ([x : (Tau S T)]) (f (lambda (z) ((x x) z))))))

(: fact : Number -> Number)
(define fact (make-recursive
              (lambda: ([fact : (Number -> Number)])
                (lambda: ([n : Number])
                  (if (zero? n)
                    1
                    (* n (fact (- n 1))))))))

(fact 5)
