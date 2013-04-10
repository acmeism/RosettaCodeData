#lang racket

;; Like "map", but the proc must take an index as well as the element.
(define (map-index proc seq)
  (for/list ([(elt i) (in-indexed seq)])
    (proc elt i)))

;; Applies PROC to every STEPth element of SEQ, leaving the others
;; unchanged.
(define (map-step proc step seq)
  (map-index
   (lambda (elt i)
     ((if (zero? (remainder i step) )
          proc
          values) elt))
   seq))

(define (toggle-nth n seq)
  (map-step not n seq))

(define (solve seq)
  (for/fold ([result seq])
      ([(_ pass) (in-indexed  seq)])
      (toggle-nth (add1 pass) result)))

(for ([(door index) (in-indexed (solve (make-vector 100 #f)))])
  (when door
    (printf "~a is open~%" index)))
