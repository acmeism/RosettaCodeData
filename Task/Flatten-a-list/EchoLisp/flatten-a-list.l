(define (fflatten l)
(cond
[(null? l) null]
[(not (list? l)) (list l)]
[else (append (fflatten (first l)) (fflatten (rest l)))]))

;;
(define L' [[1] 2 [[3 4] 5] [[[]]] [[[6]]] 7 8 []])

(fflatten L) ;; use custom function
 → (1 2 3 4 5 6 7 8)
(flatten L) ;; use built-in
 → (1 2 3 4 5 6 7 8)

;; Remarks
;; null is the same as () - the empty list -
(flatten '(null null null))
   → null
(flatten '[ () () () ])
  → null
(flatten null)
❗ error: flatten : expected list : null

;; The 'reverse' of flatten is group
(group '( 4 5 5 5 6 6 7 8 7 7 7 9))
    → ((4) (5 5 5) (6 6) (7) (8) (7 7 7) (9))
