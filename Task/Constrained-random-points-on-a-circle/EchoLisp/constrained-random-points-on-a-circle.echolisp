(lib 'math)
(lib 'plot)

(define (points (n 100) (radius 10) (rmin 10) (rmax 15)   (x) (y))
	(plot-clear)
	(plot-x-minmax (- rmax))
	(plot-y-minmax( - rmax))
	
	(for [(i n)]
	(set! x (round (* (random -1) rmax)))
	(set! y (round (* (random -1) rmax)))
	#:when (in-interval? (pythagore x y) rmin rmax)
	;; add a little bit of randomness : dots color and radius
	(plot-fill-color   (hsv->rgb (random) 0.9 0.9))
	(plot-circle x y (random radius)))
	(plot-edit))
