(define-macro m-range [a .. b] (range a (1+ b)))

(map FFR [1 .. 10])
    → (1 3 7 12 18 26 35 45 56 69)

;; checking
(equal? [1 .. 1000] (list-sort < (append (map FFR [1 .. 40]) (map FFS [1 .. 960]))))
    → #t
