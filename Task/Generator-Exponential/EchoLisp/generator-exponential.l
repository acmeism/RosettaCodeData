(lib 'tasks) ;; for make-generator

;; generator of generators
(define (gen-power power)
	(make-generator
		(lambda(n) (yield (expt n power)) (1+ n))  1))
		
(define powers-2 (gen-power 2))
(define powers-3 (gen-power 3))

(take powers-3 10)
    → (1 8 27 64 125 216 343 512 729 1000)

;; generators substraction
;; input : two generators ga, gb - Sequences must be increasing
;; output : new generator  = ga sequence minus gb sequence

(define (gen-substract ga gb)
	(define (substract b (a))
	(set! a (next ga))
	(while (>= a b) ; avance b until > a
		(when (= a b) (set! a (next ga)))
		(set! b (next gb)))
	(yield a)
	b ) ;; b := next state
	(make-generator substract (next gb)))

;; application
(define task    (gen-substract (gen-power 2) (gen-power 3)))

(drop task 20)
(take task 10)
    → (529 576 625 676 784 841 900 961 1024 1089)

; inspect
task → #generator:state: 1331
