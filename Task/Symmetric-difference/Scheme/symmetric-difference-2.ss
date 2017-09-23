(import (scheme base)
        (scheme write)
        (srfi 1))

(define (a-without-b a b)
  (lset-difference equal?
                   (delete-duplicates a)
                   (delete-duplicates b)))

(define (symmetric-difference a b)
  (lset-xor equal?
            (delete-duplicates a)
            (delete-duplicates b)))

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
