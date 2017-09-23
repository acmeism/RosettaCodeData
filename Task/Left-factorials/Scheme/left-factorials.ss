(import (scheme base)     ;; library imports in R7RS style
        (scheme write)
        (srfi 1 lists))

(define (factorial n)
  (fold * 1 (iota n 1)))

(define (left-factorial n)
  (fold + 0 (map factorial (iota n))))

(define (show i r) ; to pretty print the results
  (display "!") (display i) (display " ") (display r) (newline))

;; show left factorials for zero through ten (inclusive)
(for-each
  (lambda (i) (show i (left-factorial i)))
  (iota 11))

;; show left factorials for 20 through 110 (inclusive) by tens
(for-each
  (lambda (i) (show i (left-factorial i)))
  (iota 10 20 10))

;; number of digits in 1000 through 10000 by thousands:
(for-each
  (lambda (i) (show i (string-length (number->string (left-factorial i)))))
  (iota 10 1000 1000))
