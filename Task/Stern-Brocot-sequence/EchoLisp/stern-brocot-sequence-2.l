; generate the sequence and check GCD
(for ((n 10000))
    (unless (= (gcd (stern n) (stern (1+ n))) 1) (error "BAD GCD" n)))
    → #t

;; first items
(define sterns (cache 'stern))
(subvector sterns 1 16)
   → #( 1 1 2 1 3 2 3 1 4 3 5 2 5 3 4)

;; first occurences index
(for ((i (in-range 1 11))) (write (vector-index i sterns)))
→  0 3 5 9 11 33 19 21 35 39

;; 100
(writeln (vector-index 100 sterns))
→ 1179

(stern 900000) → 446
(stern 900001) → 2479
