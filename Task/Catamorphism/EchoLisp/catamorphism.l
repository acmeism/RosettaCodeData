;; rem : the foldX family always need an initial value
;; fold left a list
(foldl + 0 (iota 10)) ;; 0 + 1 + .. + 9
  → 45

;; fold left a sequence
(lib 'sequences)
(foldl * 1 [ 1 .. 10])
    → 362880 ;; 10!

;; folding left and right
(foldl / 1 ' ( 1 2 3 4))
    → 8/3
(foldr / 1 '(1 2 3 4))
    → 3/8

;;scanl gives the list (or sequence) of intermediate values :
(scanl * 1 '( 1 2 3 4 5))
   → (1 1 2 6 24 120)
