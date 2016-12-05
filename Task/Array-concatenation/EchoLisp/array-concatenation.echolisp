;;;; VECTORS
(vector-append (make-vector 6 42) (make-vector 4 666))
    → #( 42 42 42 42 42 42 666 666 666 666)

;;;; LISTS
(append (iota 5) (iota 6))
   → (0 1 2 3 4 0 1 2 3 4 5)

;; NB - append may also be used with sequences (lazy lists)
(lib 'sequences)
   (take (append [1 .. 7] [7 6 .. 0]) #:all)
   → (1 2 3 4 5 6 7 6 5 4 3 2 1)
