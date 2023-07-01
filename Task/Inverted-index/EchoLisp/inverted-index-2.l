;; usage : (inverted-search w1 w2 ..)
(define-syntax-rule (inverted-search w ...)
            (and-get-invert (quote w )))

;; intersects all sets referenced by words
;; returns the intersection
(define (and-get-invert words)
        (foldl
            (lambda(word res)
                 (set-intersect res (local-get-value word  INVERT)))
            FILES words))
