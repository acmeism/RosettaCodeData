;; does p include a 0 in its decimal representation ?
(define (nozero? n) (= -1 (string-index (number->string n) "0")))

;; right truncate : p and successive quotients by 10 (integer division) must be primes
(define (right-trunc p) (unless (zero? p)
	(and (prime? p) (right-trunc (quotient p 10)))))
(remember 'right-trunc)

;; left truncate : p and successive modulo by 10, 100, .. must be prime
(define (left-trunc p (mod 1000000))
	(unless (< mod 1)
	(and (prime? p) (nozero? p) (left-trunc (modulo p mod) (/ mod 10)))))

;; start from 999999. stop on first found
(define (fact-trunc trunc)
(for ((p (in-range 999999 100000 -1))) #:break (when (trunc p) (writeln p) #t)))
