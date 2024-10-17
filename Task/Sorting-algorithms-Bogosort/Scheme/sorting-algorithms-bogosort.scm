(import (rnrs base (6))
        (srfi :27 random-bits))

(define (shuffle lst)
  (define (swap! vec i j)
    (let ((tmp (vector-ref vec i)))
      (vector-set! vec i (vector-ref vec j))
      (vector-set! vec j tmp)))
  (define vec (list->vector lst))
  (let loop ((i (sub1 (vector-length vec))))
    (unless (zero? i)
      (swap! vec i (random-integer (add1 i)))
      (loop (sub1 i))))
  (vector->list vec))

(define (sorted? lst pred?)
  (cond
   ((null? (cdr lst)) #t)
   ((pred? (car lst) (cadr lst)) (sorted? (cdr lst) pred?))
   (else #f)))

(define (bogosort lst)
  (if (sorted? lst <)
      lst
      (bogosort (shuffle lst))))


(let ((input '(5 4 3 2 1)))
  (display "Input: ")
  (display input)
  (newline)
  (display "Output: ")
  (display (bogosort input))
  (newline))
