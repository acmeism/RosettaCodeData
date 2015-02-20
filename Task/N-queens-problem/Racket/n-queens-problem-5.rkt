(define (force-and-print qs)
  (define forced (force qs))
  (unless (null? forced)
    (printf "~v\n" (car forced))
    (force-and-print (cdr forced))))

(force-and-print (nqueens 8))

; =>
;(list (Q 7 3) (Q 6 1) (Q 5 6) (Q 4 2) (Q 3 5) (Q 2 7) (Q 1 4) (Q 0 0))
;(list (Q 7 4) (Q 6 1) (Q 5 3) (Q 4 6) (Q 3 2) (Q 2 7) (Q 1 5) (Q 0 0))
;(list (Q 7 2) (Q 6 4) (Q 5 1) (Q 4 7) (Q 3 5) (Q 2 3) (Q 1 6) (Q 0 0))
;(list (Q 7 2) (Q 6 5) (Q 5 3) (Q 4 1) (Q 3 7) (Q 2 4) (Q 1 6) (Q 0 0))
...
;(list (Q 7 5) (Q 6 3) (Q 5 6) (Q 4 0) (Q 3 2) (Q 2 4) (Q 1 1) (Q 0 7))
;(list (Q 7 3) (Q 6 6) (Q 5 4) (Q 4 1) (Q 3 5) (Q 2 0) (Q 1 2) (Q 0 7))
;(list (Q 7 4) (Q 6 6) (Q 5 1) (Q 4 5) (Q 3 2) (Q 2 0) (Q 1 3) (Q 0 7))
