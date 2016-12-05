(iota 12) → { 0 1 2 3 4 5 6 7 8 9 10 11 }

;; lists
(filter even? (iota 12))
    → (0 2 4 6 8 10)

;; array (non destructive)
(vector-filter even? #(1 2 3 4 5 6 7 8 9 10 11 12 13))
    → #( 2 4 6 8 10 12)

;; sequence, infinite, lazy
(lib 'sequences)
(define evens (filter even? [0 ..]))

(take evens 12)
    → (0 2 4 6 8 10 12 14 16 18 20 22)
