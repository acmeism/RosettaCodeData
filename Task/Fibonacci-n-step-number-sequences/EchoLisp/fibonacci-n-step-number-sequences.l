;; generate a recursive lambda() for a x-nacci
;; equip it with memoïzation
;; bind it to its name
(define (make-nacci name seed)
		(define len (1+ (vector-length seed)))
		(define-global name
			`(lambda(n) (for/sum ((i (in-range (1- n) (- n ,len) -1)))  (,name i))))
		(remember name seed)
		name)
		
(define nacci-family `(
	(Fibonacci #(1 1))
	(Tribonacci #(1 1 2))
	(Tetranacci #(1 1 2 4))
	(Decanacci #(1 1 2 4 8 16 32 64 128 256))
	(Random-😜-nacci ,(list->vector (take 6 (shuffle (iota 100)))))
	(Lucas #(2 1))))
	
(define (task naccis)
	(for ((nacci naccis))
		(define-values (name seed) nacci)
		(make-nacci name seed)
		(printf "%s[%d]  → %d" name (vector-length seed) (take name 16))))
