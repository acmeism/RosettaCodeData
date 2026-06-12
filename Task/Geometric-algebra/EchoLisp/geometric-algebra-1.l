(define e-bits (build-vector 32 (lambda(i) (arithmetic-shift 1 i)))) ;; 1,2,4,..
(define (e-index i) ;; index of ei in native vector
	(if (zero? i) 0 (arithmetic-shift 1 (1- i))))
				
(define DIM 0) ;; 2^N
(define N 0)
(define MultTable null) ;; multiplication table eijk * el.. = exyz..
(define SignTable null) ;; sign of products
(define Signature null) ;; input quadratic form

;; return "eijk"
(define( e-print E  sign )
	(string-append
		(cond ((= sign 1) " ") ((= sign -1) "- ") (else ""))
	  (if (zero? E) "1"
	  (for/string ((i  N))
	  #:continue (zero? (bitwise-and E (vector-ref e-bits  i)))
	  (string-append "e" (1+ i))))))
	
;; returns a string a *e1 + b*e2 + .. z*eijk + ..
(define (multi-print V (x))
	(for/string ((i DIM))
	(set! x (vector-ref V i))
	#:continue (zero? x)
	(string-append " " (if (> x 0) "+" "") x  "*" (e-print i 0))))
		
		
;; generates the multiplication table e_i e__k . * e_j e_l ..==> e_u e_v ...
;; E_I and E_J are sets of indices >=1 , increasing order,  represented by a 32 bits number

(define (make-mult-table (verbose #f) (result) (swaps) (ej))
(when verbose (writeln 'N= N 'DIM= DIM 'Q= Signature))
(for* ((E_I (in-range 1 DIM))(E_J (in-range 1 DIM)))
		(set! result E_I)
		(set! swaps 0)
		(for ((j DIM)) ; each bit# in E_J
		(set! ej (vector-ref e-bits j))
		#:continue (zero? (bitwise-and  ej E_J))

			(for((s (in-range (1- N) j -1))) ;; count swaps
				(when (!zero? (bitwise-and E_I (vector-ref e-bits s)))
					  (set! swaps (1+ swaps))))

		(if (zero? (bitwise-and E_I ej)) ;; e_i * e_j
		(set! result (bitwise-ior result ej))
		(begin ;; else e_i * e_i
		(set! result (bitwise-xor result ej))
		(when (= -1 (vector-ref Signature ej)) (set! swaps (1+ swaps)))
		))) ;; j loop
		
		(when verbose (writeln  (e-print E_I 0) '* (e-print E_J 0)
				'= (e-print result  (if (even? swaps) 1 -1))))
				
		(matrix-set! MultTable E_I E_J result)
		(matrix-set! SignTable E_I E_J (if (even? swaps) 1 -1))
		))
		
;; multivector operations
;; addition is standard vector addition
;; multiplication a  b -> c
(define (multi-mult  a b)
	(define c (make-vector DIM 0))
	(for* ((i DIM) (j DIM))
		#:continue (zero? (vector-ref a i))
		#:continue (zero? (vector-ref b j))
		(vector-set! c
			(array-ref MultTable i j)
			(+
				(* (array-ref  SignTable i j) (vector-ref a i) (vector-ref b j))
				(vector-ref c (array-ref MultTable i j)))))
		c)
		
;; pretty print  a • b or a • b • c
(define ( • a b (c #f))
	(multi-print
	(if c  (multi-mult a (multi-mult b c)) (multi-mult a b))))
			
		
;; (Eij i j) ->  return multi-vector eiej 0 <= i <= n
(define (Eij i j (coeff 1))
	(define Eij (make-vector DIM))
	(vector-set! Eij (array-ref MultTable (e-index i) (e-index j)) coeff)
	Eij)
	
	
;; Reference : https://en.wikipedia.org/wiki/Clifford_algebra#Real_numbers

;; (make-cga  m p [verbose])  => Algebra A(m p)
;; Input : a quadratic form Q(x) =  x1*x1 + + xm*xm - xm+1*xm+1 - xm+p*xm+p
;; n = m + p = dimension of vector space R^n
;; generates an algebra A(m p) of dimension  DIM  = 2^n
;; Ex : A(n 0) = use R^n dot product as quadratic form : ei*ei = 1
;; Ex : A (0 1) = Complex , e1*e1 = -1 ;  A(0 2) => quaternions ei*ei = -1
;;
;; Implementation
;; limitation n <= 5
;; multivectors of A(m p) will be mapped on Vectors  V of dimension 2^n
;; V[0] is the scalar part of a multivector.
;; Blade of vectors of R^n :  :V[2^(i-1)] = 1 , 0 elsewhere , i in [1 ..n]

(define (make-cga m p (verbose #f))
(string-delimiter "")
	(set! N (+ m p))
	(set! DIM (expt 2 N))
	(set! MultTable (build-array DIM DIM (lambda(i j) (cond ((zero? i) j)((zero? j) i)(else 0)))))
	(set! SignTable (make-array DIM DIM 1))
	(set! Signature (make-vector DIM 1)) ;; Q polynomial
	(for ((j (in-range m N))) (vector-set! Signature (vector-ref e-bits j) -1))

	(make-mult-table verbose) DIM )
	
	
