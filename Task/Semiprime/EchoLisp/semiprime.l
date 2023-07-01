(lib 'math)
(define (semi-prime? n)
   (= (length (prime-factors n)) 2))

(for ((i 100))
    (when (semi-prime? i) (write i)))

4 6 9 10 14 15 21 22 25 26 33 34 35 38 39 46 49 51 55 57 58 62 65 69 74 77 82 85 86 87 91 93 94 95

(lib 'bigint)
(define N (* (random-prime 10000000) (random-prime 10000000)))
   → 6764578882969
(semi-prime? N)
    → #t

;; a pair n,n+1 of semi-primes
(prime-factors 100000000041)
    → (3 33333333347)
(prime-factors 100000000042)
    → (2 50000000021)
