(lib 'math) ;; for poly multiplication

;; convert string of decimal digits to polynomial
;; "1234" → x^3 +2x^2 +3x +4
;; least-significant digit first
(define (string->long N)
	(reverse (map string->number (string->list N))))
	
;; convert polynomial to string
(define (long->string N)
(if (pair? N)
   (string-append (number->string (first N)) (long->string (rest N)))  ""))

;; convert poly coefficients to base 10
(define (poly->10 P (carry 0))
(append
	(for/list ((coeff P))
		(set! coeff (+ carry coeff ))
		(set! carry (quotient coeff 10)) ;; new carry
		(modulo coeff 10))
	(if(zero? carry) null (list carry)))) ;; remove leading 0 if any

;; long multiplication
;; convert input - strings of decimal digits - to polynomials
;; perform poly multiplication in base 10
;; convert result to string of decimal digits

(define (long-mul A B )
 (long->string (reverse  (poly->10 (poly-mul (string->long A) (string->long B))))))

(define two-64 "18446744073709551616")
(long-mul two-64 two-64)
    → "340282366920938463463374607431768211456"

;; check it
(lib 'bigint)
Lib: bigint.lib loaded.
(expt 2 128)
   → 340282366920938463463374607431768211456
