;;
;; using the native (combinations) function
(lib 'list)
(combinations (iota 5) 3)
→ ((0 1 2) (0 1 3) (0 1 4) (0 2 3) (0 2 4) (0 3 4) (1 2 3) (1 2 4) (1 3 4) (2 3 4))
;;
;; using an iterator
;;
(lib 'sequences)
(take (combinator (iota 5) 3) #:all)
→ ((0 1 2) (0 1 3) (0 1 4) (0 2 3) (0 2 4) (0 3 4) (1 2 3) (1 2 4) (1 3 4) (2 3 4))
;;
;; defining a function
;;
(define (combine lst p) (cond
    [(null? lst) null]
    [(< (length lst) p) null]
    [(= (length lst) p) (list lst)]
    [(= p 1) (map list lst)]
    [else (append
        (map cons (circular-list (first lst)) (combine (rest lst) (1- p)))
        (combine (rest lst) p))]))

(combine (iota 5) 3)
    → ((0 1 2) (0 1 3) (0 1 4) (0 2 3) (0 2 4) (0 3 4) (1 2 3) (1 2 4) (1 3 4) (2 3 4))
