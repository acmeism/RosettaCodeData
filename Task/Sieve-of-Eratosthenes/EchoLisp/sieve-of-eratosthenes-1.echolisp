(require 'types) ;; bit-vector

;; converts sieve->list for integers in [nmin .. nmax[
(define (s-range sieve nmin nmax (base 0))
	(for/list ([ i (in-range nmin nmax)]) #:when (bit-vector-ref sieve i) (+ i base)))
	
;; next prime in sieve > p, or #f
(define (s-next-prime sieve p ) ;;
		(bit-vector-scan-1 sieve (1+ p)))
		

;; returns a bit-vector - sieve- all numbers in [0..n[
(define (eratosthenes n)
  (define primes (make-bit-vector-1 n ))
  (bit-vector-set! primes 0 #f)
  (bit-vector-set! primes 1 #f)
  (for ([p (1+ (sqrt n))])
  		 #:when (bit-vector-ref primes  p)
         (for ([j (in-range (* p p) n p)])
    (bit-vector-set! primes j #f)))
   primes)

(define s-primes (eratosthenes 10_000_000))

(s-range s-primes 0 100)
   → (2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
(s-range s-primes 1_000_000 1_000_100)
   → (1000003 1000033 1000037 1000039 1000081 1000099)
(s-next-prime s-primes 9_000_000)
   → 9000011
