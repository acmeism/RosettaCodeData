(setq Legendre-Max (** 10 9))

(load "plcommon/eratosthenes.l")  # see task "Sieve of Eratosthenes, 2x3x5x7 wheel version.

# Create an index tree of the first N primes up to √Legendre-Max
(setq Sieve (sieve (sqrt Legendre-Max)))
(balance 'Primes (mapcar 'cons (range 1 (length Sieve)) Sieve))
(de prime (N)  (cdr (lup Primes N)))

(de ϕ (X A)
   (cache '(NIL) (cons X A)
      (if (=0 A)
         X
         (- (ϕ X (dec A)) (ϕ (/ X (prime A)) (dec A))))))

(de π (N)
   (if (< N 2)
      0
      (let A (π (sqrt N))
         (+ (ϕ N A) A -1))))

(for N 10
   (prinl "10\^" (dec N) "^I" (π (** 10 (dec N)))))

(bye)
