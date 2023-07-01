(define (insert-after lst target item)
    (when (null? lst) (error "cannot insert in" null))
    (let [(sub-list (member target lst))]
        (if sub-list (set-cdr! sub-list (cons item (cdr sub-list))) ; make chirurgy if found
        (nconc lst item)))) ; else append item

(define L '(a b))
(insert-after L 'a 'c)
    L  → (a c b)
(insert-after L 'x 'y)
    L → (a c b y)
