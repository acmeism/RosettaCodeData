#!r6rs
(import (rnrs base (6))
        (srfi :27 random-bits))

(define (vector-swap! vec i j)
  (let
      ((temp (vector-ref vec i)))
    (vector-set! vec i (vector-ref vec j))
    (vector-set! vec j temp)))

(define (countdown n)
  (if (zero? n)
      ()
      (cons n (countdown (- n 1)))))

(define (vector-shuffle! vec)
  (for-each
   (lambda (i)
     (let
         ((j (random-integer i)))
       (vector-swap! vec (- i 1) j)))
   (countdown (vector-length vec))))
