; the first twenty primes
(primes 20)
    → { 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 }

; a stream to generate primes from a
(define (primes-from a)
    (let ((p (next-prime a)))
     (stream-cons p (primes-from p))))

; primes between 100,150
(for/list  ((p (primes-from 100)))  #:break  (> p 150) p)
    → (101 103 107 109 113 127 131 137 139 149)

; the built-in function (primes-pi )counts the number of primes < a
; count in [7700 ...  8000]
(- (primes-pi 8000) (primes-pi 7700) → 30

; nth-prime
(nth-prime 10000) → 104729

;; big ones
(lib 'bigint)
(define (p-digits n)
  (printf "(next-prime  %d ! ) has %d digits" n
  (number-length (next-prime (factorial n )))))

(next-prime 0! ) has 1 digits
(next-prime 10! ) has 7 digits
(next-prime 100! ) has 158 digits
(next-prime 200! ) has 375 digits
(next-prime 300! ) has 615 digits
(next-prime 400! ) has 869 digits ;; 9400 msec (FireFox)

; is prime (1 + 116!) ?
(prime? (1+ (factorial 116)))  → #t
