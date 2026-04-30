(import (srfi 231))

(define (matrix* A B)
  (array-copy! (array-inner-product A + * B)))

(define (matrix-square A)
  (matrix* A A))

(define (matrix-identity A)
  (array-copy! (make-array (array-domain A)
                           (lambda (i j) (if (= i j) 1 0)))))

(define (matrix-expt A n)
  (cond ((zero? n) (matrix-identity A))
        ((= 1 n) A)
        ((even? n) (matrix-expt (matrix-square A)
                                (quotient n 2)))
        (else (matrix* A (matrix-expt (matrix-square A)
                                      (quotient n 2))))))

(define a
  (list*->array 2 '((3 2)
                    (2 1))))

(for-each (lambda (i)
            (for-each display
                      (list "a^" i " = " (array->list* (matrix-expt a i)) #\newline)))
          (iota 11))
