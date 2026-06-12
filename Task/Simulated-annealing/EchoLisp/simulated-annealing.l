(lib 'math)
;; distances
(define (d ci cj)
	(distance (% ci 10) (quotient ci 10)  (% cj 10) (quotient cj 10)))
(define _dists
	(build-vector 10000 (lambda (ij) (d  (quotient ij 100) (% ij 100)))))
(define-syntax-rule  (dist ci cj)
		[_dists (+ ci (* 100 cj))])
	
;; E(s) = length(path)
(define (Es path)
	(define lpath (vector->list path))
	(for/sum ((ci lpath) (cj (rest lpath))) (dist ci cj)))
	
;; temperature() function
(define (T k kmax kT)
		(* kT (- 1  (// k kmax))))
#|
;; alternative temperature()
;; must be decreasing with k increasing and → 0
(define (T k kmax kT)
	(* kT (- 1  (sin (* PI/2  (// k kmax))))))
|#

;; ∆E = Es_new - Es_old >  0
;; probability to move if ∆E > 0,  → 0 when T → 0 (frozen state)
(define (P ∆E k kmax kT)
		(exp (// (- ∆E ) (T k kmax kT))))
		
;;  ∆E from path ( .. a u b .. c v d ..) to (.. a v b ... c u d ..)
;;  ∆E before swapping (u,v)
;;  Quicker than Es(s_next) - Es(s)

(define (dE s u v)
;;old
		(define a (dist [s (1- u)] [s u]))
		(define b (dist [s (1+ u)] [s u]))
		(define c (dist [s (1- v)] [s v]))
		(define d  (dist [s (1+ v)] [s v]))
;; new
		(define na (dist [s (1- u)] [s v]))
		(define nb (dist [s (1+ u)] [s v]))
		(define nc (dist [s (1- v)] [s u]))
		(define nd (dist [s (1+ v)] [s u]))
				
		(cond
		((= v (1+ u)) (- (+ na nd) (+ a d)))
		((= u (1+ v)) (- (+ nc nb) (+ c b)))
		(else (- (+ na nb nc nd) (+ a b c d)))))

;; all 8 neighbours
(define dirs #(1 -1 10 -10 9 11 -11 -9))

(define (sa  kmax (kT 10))
	(define s (list->vector (cons 0 (append (shuffle (range 1 100)) 0))))
	(printf "E(s0) %d" (Es s)) ;; random starter
	(define Emin (Es s)) ;; E0
	
	(for ((k kmax))
	(when (zero? (% k (/ kmax 10)))
		(printf "k: %10d T: %8.4d Es: %8.4d" k  (T k kmax kT) (Es s))
		)
		
		(define u (1+ (random 99))) ;; city index 1 99
		(define cv (+ [s u] [dirs (random 8)])) ;; city number
		#:continue (or (> cv 99) (<= cv 0))
		#:continue (> (dist [s u] cv) 5) ;; check true neighbour (eg 0 9)
		(define v (vector-index cv s 1)) ;; city index
		
		(define ∆e (dE s u v))
		(when (or
			(< ∆e 0)  ;; always move if negative
			(>= (P ∆e k kmax kT) (random)))
				(vector-swap! s u v)
				(+= Emin ∆e))
			
		;; (assert  (= (round Emin) (round (Es s))))
		) ;; for
		
		(printf "k: %10d T: %8.4d Es: %8.4d" kmax  (T (1- kmax) kmax kT) (Es s))
		(s-plot s 0)
		(printf "E(s_final) %d" Emin)
		(writeln 'Path s))
