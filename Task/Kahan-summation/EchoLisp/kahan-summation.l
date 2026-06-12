;; using floating point arithmetic
;; the maximum number of decimals is 17. Floating point arithmetic is not always 100% accurate
;; even with simple data :

(+ 0.2 0.1 0.3)  → 0.6000000000000001 ;; (1)

;; 👀 Will Kahan method do better ??
;; Kahan procedure :

(define  ( K+ nums ( sum 0.0) (c 0.0) (y) (t))
	(while (!null? nums)
		(set! y (- (first nums) c))
		(set! t (+ sum y))
		(set! c (- (- t sum) y))
		(set! sum t)
		(set! nums (rest nums)))
		sum)

;; 👏 👏 Kahan improves on the above (1)
(K+ '( 0.2 0.1 0.3))  → 0.6

;; using epsilon such as (1.0 + epsilon) = 1.0
;; compute 1 + epsilon - epsilon :

(define eps 1.0)
     (while (!= (+ 1.0 eps) 1.0) (set! eps (// eps 2.0)))
eps → 1.1102230246251565e-16

(define a  1.0 )
(define b eps)
(define c (- b))

(writeln 'standard-add= (+ a b c))
(writeln 'Kahan-add= (K+ (list a b c)))

    → standard-add= 0.9999999999999999
    → Kahan-add= 1

;;NB. The 17-nth decimal we gain using Kahan method will probably be lost in subsequent calculations.
;;Kahan algorithm will be useful for fixed-point decimal calculations, which EchoLisp does not have.
