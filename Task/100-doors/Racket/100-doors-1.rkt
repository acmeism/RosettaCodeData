#lang racket

;; Applies fun to every step-th element of seq, leaving the others unchanged.
(define (map-step fun step seq)
  (for/list ([elt seq] [i (in-naturals)])
    ((if (zero? (modulo i step)) fun values) elt)))

(define (toggle-nth n seq)
  (map-step not n seq))

(define (solve seq)
  (for/fold ([result seq]) ([_ seq] [pass (in-naturals 1)])
    (toggle-nth pass result)))

(for ([door (solve (make-vector 101 #f))] [index (in-naturals)]
      #:when (and door (> index 0)))
  (printf "~a is open~%" index))
