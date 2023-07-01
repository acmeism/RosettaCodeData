(require '(heap compile))

(define (scube a b) (+ (* a a a) (* b b b)))
(compile 'scube "-f") ; "-f" means : no bigint, no rational used

;; is n - a^3 a cube  b^3?
;; if yes return b, else #f
(define (taxi? n a (b 0))
	(set! b (cbrt (- n (* a a a)))) ;; cbrt is ∛
	(when (and (< b a) (integer? b)) b))
(compile 'taxi? "-f")

#|-------------------
looking for taxis
--------------------|#
;; remove from heap until heap-top >= a
;; when twins are removed, it is a taxicab number : push it
;; at any time (top stack) = last removed

(define (clean-taxi H limit: a  min-of-heap: htop)
		(when (and htop (> a htop))
				(when (!= (stack-top S) htop) (pop S))
				(push S htop)
				(heap-pop H)
				(clean-taxi H  a (heap-top H))))
(compile 'clean-taxi "-f")
				
;; loop on a and b, b <=a , until n taxicabs found
(define (taxicab (n 2100))
	(for ((a (in-naturals)))
		(clean-taxi H (* a a a) (heap-top H))
		#:break (> (stack-length S) n)
		(for ((b a))
			(heap-push H (scube a b)))))
				
#|------------------
printing taxis
---------------------|#
;; string of all decompositions
(define (taxi->string i n)
	(string-append (format "%d. %d " (1+ i) n)
	(for/string ((a (cbrt n)))
		#:when (taxi? n a)
		(format " = %4d^3 + %4d^3" a (taxi? n a)))))
		
(define (taxi-print taxis (nfrom 0) (nto 26))
		(for ((i (in-naturals nfrom)) (taxi (sublist taxis nfrom nto)))
		(writeln (taxi->string i (first taxi)))))
