(import (scheme base)
        (scheme write))

;; -- given two sets represented as lists, return (A \ B)
(define (a-without-b a b)
  (cond ((null? a)
         '())
        ((member (car a) (cdr a)) ; drop head of a if it's a duplicate
         (a-without-b (cdr a) b))
        ((member (car a) b) ; head of a is in b so drop it
         (a-without-b (cdr a) b))
        (else ; head of a not in b, so keep it
          (cons (car a) (a-without-b (cdr a) b)))))

;; -- given two sets represented as lists, return symmetric difference
(define (symmetric-difference a b)
  (append (a-without-b a b)
          (a-without-b b a)))

;; -- test case
(define A '(John Bob Mary Serena))
(define B '(Jim Mary John Bob))

(display "A\\B: ") (display (a-without-b A B)) (newline)
(display "B\\A: ") (display (a-without-b B A)) (newline)
(display "Symmetric difference: ") (display (symmetric-difference A B)) (newline)
;; -- extra test as we are using lists
(display "Symmetric difference 2: ")
(display (symmetric-difference '(John Serena Bob Mary Serena)
                               '(Jim Mary John Jim Bob))) (newline)
