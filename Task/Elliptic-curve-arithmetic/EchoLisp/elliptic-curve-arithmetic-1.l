(require 'struct)
(decimals 4)
(string-delimiter "")
(struct pt (x y))

(define-syntax-id _.x (struct-get _ #:pt.x))
(define-syntax-id _.y (struct-get _ #:pt.y))

(define (E-zero) (pt Infinity Infinity))
(define (E-zero? p) (=  (abs p.x) Infinity))
(define (E-neg p) (pt  p.x  (- p.y)))

;; magic formulae from "C"
;; p + p
(define (E-dbl p)
	(if (E-zero? p) p
	(let* (
	[L (// (* 3 p.x p.x) (* 2 p.y))]
	[rx (- (* L L) (* 2 p.x))]
	[ry (- (* L (- p.x rx)) p.y)]
	)
	(pt rx ry))))
	
;; p + q
(define (E-add p q)
(cond
 [ (and (= p.x p.x) (= p.y q.y)) (E-dbl p)]
 [ (E-zero? p) q ]
 [ (E-zero? q) p ]
 [ else
 	(let* (
 	[L (// (- q.y p.y) (- q.x p.x))]
 	[rx (- (* L L) p.x q.x)] ;; match
 	[ry (- (* L (- p.x rx)) p.y)]
 	)
 	(pt rx ry))]))
 	
 ;; (E-add* a b c ...)
(define (E-add* . pts) (foldl E-add (E-zero) pts))

;; p * n
(define (E-mul p n (r (E-zero)) (i 1))
	(while (<= i n)
		(when (!zero? (bitwise-and i n))  (set! r (E-add r p)))
		(set! p (E-dbl p))
		(set! i (* i 2)))
	r)
	
;; make points from x or y
(define (Ey.pt y  (c 7))
	(pt (expt (- (* y y) c) 1/3 ) y))
(define (Ex.pt x  (c 7))
	(pt x (sqrt (+ ( * x x x ) c))))

	
;; Check floating point precision
;; P * n is not always P+P+P+P....P

(define (E-ckmul a n )
	(define e a)
	(for ((i (in-range 1 n))) (set! e (E-add a e)))
	(printf "%d additions a+(a+(a+...)))  → %a" n e)
	(printf "multiplication a x %d        → %a" n (E-mul a n)))
