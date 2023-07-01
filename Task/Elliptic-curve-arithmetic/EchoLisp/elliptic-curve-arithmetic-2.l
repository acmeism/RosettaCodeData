(define (E-plot (r 3))
	(define (Ellie x y) (- (* y y) (* x x x) 7))
	(define P (Ey.pt 0))
	(define Q (Ex.pt 0))
	(define R (E-add P Q))
	
	(plot-clear)
	(plot-xy Ellie -10 -10) ;; curve
	(plot-axis 0 0 "red")
	(plot-circle P.x P.y r) ;; points
	(plot-circle Q.x Q.y r)
	(plot-circle R.x R.y r)
	(plot-circle R.x (- R.y) r)
	(plot-segment P.x P.y R.x (- R.y))
	(plot-segment R.x R.y R.x (- R.y))
	)
