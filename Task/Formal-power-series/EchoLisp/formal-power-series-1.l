(require 'math)
;; converts a finite polynomial (a_0 a_1 .. a_n) to an infinite serie (a_0 ..a_n 0 0 0 ...)
(define (poly->stream list)
	(make-stream (lambda(n) (cons (if (< n (length list)) (list-ref list n) 0) (1+ n))) 0))

;; c = a + b , c_n = a_n + b_n
(define (s-add a b)
	(make-stream (lambda (n) (cons (+ (stream-ref a n) (stream-ref b n)) (1+ n))) 0))
	
;; c = a * b , c_n = ∑ (0 ..n) a_i * b_n-i
(define (s-mul-coeff n a b) (sigma (lambda(i) (* (stream-ref a i)(stream-ref b (- n i)))) 0 n))

(define (s-mul a b)
	(make-stream (lambda(n) (cons (s-mul-coeff n a b) (1+ n))) 0))

;; b = 1/a ; b_0 = 1/a_0, b_n =  - ∑ (1..n) a_i * b_n-i / a_0
(define (s-inv-coeff n a b)
			(if (zero? n) (/ (stream-ref a 0))
			(- (/ (sigma (lambda(i) (* (stream-ref a i)(stream-ref b (- n i)))) 1 n)
			 (stream-ref a 0)))))

;; note the self keyword which refers to b = (s-inv a)
(define (s-inv a)
	(make-stream (lambda(n) (cons (s-inv-coeff n a self ) (1+ n))) 0))

;; b = (s-k-add k a) = k + a_0, a_1, a_2, ...
(define (s-k-add k a)
	(make-stream (lambda(n) (cons
	(if(zero? n) (+ k (stream-ref a 0)) (stream-ref a n)) (1+ n))) 0))
	
;; b = (s-neg a) = -a_0,-a_1, ....
(define (s-neg a)
	(make-stream (lambda(n) (cons (- (stream-ref a n)) (1+ n))) 0))

;; b = (s-int a) = ∫ a ; b_0 = 0 by convention, b_n = a_n-1/n
(define (s-int a)
	(make-stream (lambda(n) (cons (if (zero? n) 0 (/ (stream-ref a (1- n)) n)) (1+ n))) 0))
	
;; value of power serie at x, n terms
(define (s-value a x (n 20))
	(poly x (take a n)))

;; stream-cons allows mutual delayed references
;; sin = ∫ cos
(define sin-x (stream-cons 0 (stream-rest (s-int cos-x))))
;; cos = 1 - ∫ sin
(define cos-x (stream-cons 1 (stream-rest (s-k-add 1  (s-neg (s-int sin-x))))))
