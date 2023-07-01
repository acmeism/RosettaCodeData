#lang racket
(define MAX 250)
(define pow5 (make-vector MAX))
(for ([i (in-range 1 MAX)])
  (vector-set! pow5 i (expt i 5)))
(define pow5s (list->set (vector->list pow5)))
(let/ec break
  (for* ([x0 (in-range 1 MAX)]
         [x1 (in-range 1 x0)]
         [x2 (in-range 1 x1)]
         [x3 (in-range 1 x2)])
    (define sum (+ (vector-ref pow5 x0)
                   (vector-ref pow5 x1)
                   (vector-ref pow5 x2)
                   (vector-ref pow5 x3)))
    (when (set-member? pow5s sum)
      (displayln (list x0 x1 x2 x3 (inexact->exact (round (expt sum 1/5)))))
      (break))))
