(lib 'math.lib)
;; 1 - x^p  :  P = (1 0 0 0 ... 0 -1)
(define (mono p) (append (list 1) (make-list (1- p) 0) (list -1)))

;; compute (x-1)^p ,  p >= 1
(define (aks-poly p)
	(poly-pow (list -1 1) p))
	
;;
(define (show-them n)
	(for ((p (in-range 1 n)))
		(writeln 'p p (poly->string 'x (aks-poly p)))))
	
;; aks-test
;; P = (x-1)^p + 1 - x^p
(define (aks-test p)
	(let ((P (poly-add (mono p) (aks-poly p)))
	    (test (lambda(a) (zero? (modulo a p))))) ;; p divides a[i] ?
	    (apply and (map test P)))) ;; returns #t if true for all a[i]
