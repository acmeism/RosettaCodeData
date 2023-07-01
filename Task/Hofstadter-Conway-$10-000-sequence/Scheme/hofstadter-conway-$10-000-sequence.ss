(import (scheme base)
        (scheme write)
        (only (srfi 1) iota))

;; maximum size of sequence to consider, as a power of 2
(define *max-power* 20)
(define *size* (expt 2 *max-power*))

;; Task 1: Generate members of the sequence
(define *seq* (make-vector (+ 1 *size*))) ; add 1, to use 1-indexing into sequence

(vector-set! *seq* 1 1)
(vector-set! *seq* 2 1)
(for-each
  (lambda (n)
    (let ((x (vector-ref *seq* (- n 1))))
      (vector-set! *seq* n (+ (vector-ref *seq* x)
                              (vector-ref *seq* (- n x))))))
  (iota (- *size* 2) 3))

;; Task 2: Show maxima of a(n)/n between successive powers of two
(for-each
  (lambda (power)
    (let ((start-idx (+ (expt 2 (- power 1)) 1))
          (end-idx (expt 2 power)))
      (do ((i start-idx (+ 1 i))
           (maximum 0 (max maximum (/ (vector-ref *seq* i)
                                      i))))
        ((> i end-idx)
         (display
           (string-append
             "Maximum between 2^" (number->string (- power 1))
             " and 2^" (number->string power)
             " = " (number->string (inexact maximum))
             "\n"))))))
  (iota (- *max-power* 1) 2))

;; Task 3: Find value of p where a(n)/n < 0.55 for all n > p (in our sequence)
(do ((idx *size* (- idx 1)))
  ((or (zero? idx) ; safety net
       (> (/ (vector-ref *seq* idx) idx)
          0.55))
    (display (string-append "\np=" (number->string idx) "\n"))))
