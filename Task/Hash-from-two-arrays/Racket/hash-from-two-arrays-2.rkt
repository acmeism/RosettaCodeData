(define (connect keys vals)  (for/hash ([k keys] [v vals]) (values k v)))
;; Example:
(connect #("a" "b" "c" "d") #(1 2 3 4))
