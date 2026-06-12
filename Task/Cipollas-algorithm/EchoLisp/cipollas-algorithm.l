(lib 'struct)
(lib 'types)
(lib 'bigint)

;; test equality mod p
(define-syntax-rule (mod= a b p)
	 (zero?  (% (- a b) p)))

(define (Legendre a p)
	 (powmod a (/ (1- p) 2) p))

;; Arithmetic in Fp²
(struct Fp² ( x y ))
;; a + b
(define (Fp²-add Fp²:a Fp²:b p ω2)
	(Fp² (% (+ a.x b.x) p) (% (+ a.y b.y) p)))
;; a * b
(define (Fp²-mul Fp²:a Fp²:b p ω2)
	(Fp² (% (+ (* a.x b.x) (* ω2 a.y b.y)) p) (% (+ (* a.x b.y) (* a.y b.x)) p)))

;; a * a	
(define (Fp²-square Fp²:a p ω2)
	(Fp² (% (+ (* a.x a.x) (* ω2 a.y a.y)) p) (%  (* 2 a.x a.y)  p)))

;; a ^ n
(define (Fp²-pow Fp²:a n p ω2)
	(cond
	((= 0 n) (Fp² 1 0))
	((= 1 n) (Fp² a.x a.y))
	((= 2 n) (Fp²-mul a a p ω2))
	((even? n) (Fp²-square (Fp²-pow a (/ n 2) p ω2) p ω2))
	(else (Fp²-mul a (Fp²-pow a (1- n) p ω2) p ω2))))

;; x^2 ≡ n (mod p) ?
(define (Cipolla n p)
;; check n is a square
	(unless (= 1 (Legendre n p)) (error "not a square (mod p)" (list n p)))
;; iterate until suitable 'a' found
	(define a
		(for ((t (in-range 2 p))) ;; t = tentative a
		  #:break (= (1- p)  (Legendre (- (* t t) n) p)) => t
		))
	(define ω2 (- (* a a) n))
	;; (writeln 'a-> a 'ω2-> ω2 'ω-> 'ω)
	;; (Fp² a 1) = a + ω
	(define r   (Fp²-pow (Fp² a 1) (/ (1+ p) 2) p ω2))
	;; (writeln 'r r)
	(define x  (Fp²-x r))
	(assert (zero? (Fp²-y r))) ;; hope that ω has vanished
	(assert (mod= n (* x x) p)) ;; checking the result
	(printf "Roots of %d are (%d,%d)  (mod %d)" n  x  (% (- p x) p) p))
