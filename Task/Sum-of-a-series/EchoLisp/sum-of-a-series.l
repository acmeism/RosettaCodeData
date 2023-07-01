(lib 'math) ;; for (sigma f(n) nfrom nto) function
(Σ (λ(n) (// (* n n))) 1 1000)
;; or
(sigma (lambda(n) (// (* n n))) 1 1000)
    → 1.6439345666815615

(// (* PI PI) 6)
    → 1.6449340668482264
