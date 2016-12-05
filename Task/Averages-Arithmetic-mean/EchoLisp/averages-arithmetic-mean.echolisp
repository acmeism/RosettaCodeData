(lib 'math)
(mean '(1 2 3 4)) ;; mean of a list
    → 2.5
(mean #(1 2 3 4)) ;; mean of a vector
    → 2.5

(lib 'sequences)
(mean [1 3 .. 10]) ;; mean of a sequence
    → 5

;; error handling
(mean 'elvis)
    ⛔ error: mean : expected sequence : elvis
(mean ())
    💣 error: mean : null is not an object
(mean #())
    😐 warning: mean : zero-divide : empty-vector
    → 0
(mean [2 2 .. 2])
    😁 warning: mean : zero-divide : empty-sequence
    → 0
