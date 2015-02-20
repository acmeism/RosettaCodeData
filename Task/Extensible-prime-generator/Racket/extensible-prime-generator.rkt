#lang racket
;; Using the prime functions from:
(require math/number-theory)

(displayln "Show the first twenty primes.")
(next-primes 1 20)

(displayln "Show the primes between 100 and 150.")
;; Note that in each of the in-range filters I "add1" to the stop value, so that (in this case) 150 is
;; considered. I'm pretty sure it's not prime... but technology moves so fast nowadays that things
;; might have changed!
(for/list ((i (sequence-filter prime? (in-range 100 (add1 150))))) i)

(displayln "Show the number of primes between 7,700 and 8,000.")
;; (for/sum (...) 1) counts the values in a sequence
(for/sum ((i (sequence-filter prime? (in-range 7700 (add1 8000))))) 1)

(displayln "Show the 10,000th prime.")
(nth-prime (sub1 10000)) ; (nth-prime 0) => 2

;; If a languages in-built prime generator is extensible or is guaranteed to generate primes up to a
;; system limit, (2^31 or memory overflow for example), then this may be used as long as an
;; explanation of the limits of the prime generator is also given. (Which may include a link
;; to/excerpt from, language documentation).
;;
;; Full details in:
;; [[http://docs.racket-lang.org/math/number-theory.html?q=prime%3F#%28part._primes%29]]
;; When reading the manual, note that "Integer" and "Natural" are unlimited (or bounded by whatever
;; big number representation there is (and the computational complexity of the work being asked).
(define 2^256 (expt 2 256))
2^256
(next-prime 2^256)
;; (Oh, and this is a 64-bit laptop, I left my 256-bit PC in the office.)
