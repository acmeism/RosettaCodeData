#lang racket

(define (square-root-by-hand I digits-remaining)
  (define j (integer-sqrt I))
  (define (loop d i j k n need-dot?)
    (display d)
    (when need-dot? (display "."))
    (flush-output)
    (let* ((i (* 100 (- i (* k d))))
           (k (* 10 I j))
           (d (sub1 (for/first ((d (in-range 1 11)) #:when (> (* d (+ k d)) i)) d))))
      (unless (or (zero? i) (and n (zero? n)))
        (loop d i (+ (* 10 j) d) (+ k d) (and n (sub1 n)) #f))))
  (loop j I j j digits-remaining #t)
  (newline))

(square-root-by-hand 2 1000)
(square-root-by-hand 256 100)
(square-root-by-hand 144 #f)
