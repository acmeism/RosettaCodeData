(define (step-color x y n last-one)
		(letrec ((sq (square (floor x) (floor y) n))
		(step (vector-ref *hit-squares* sq) n n))
		(cond ((= 0 step) (rgb 1 0 0)) ;; red starter
			  ((= last-one step) (rgb 0 1 0)) ;; green end
			  (else (gray (// step n n))))))
		
(define  ( k-plot n)
	(plot-rgb (lambda (x y) (step-color x y n (dim n))) (- n epsilon) (- n epsilon)))
