(lib 'math) ;; for egcd = extended gcd

(define (mod-inv x m)
    (define-values (g inv q) (egcd x m))
    (unless (= 1 g) (error 'not-coprimes (list x m) ))
    (if (< inv 0) (+ m inv) inv))

(mod-inv 42 2017)  → 1969
(mod-inv 42 666)
🔴 error: not-coprimes (42 666)
