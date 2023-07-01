(lib 'plot)
(lib 'types)

(define (move iter x dir constant: plane turns cmax  width  xmax (cidx 0))
	(while (> iter 0)
	;; get color index of current square
	(set! cidx (vector-ref plane x))

	;; turn	
	(if (vector-ref turns cidx)
		(set! dir (if (= dir 3) 0 (1+ dir))) ;; right is #t
		(set! dir (if (= dir 0) 3 (1- dir))))

	;; rotate colors
	(set! cidx (if (= cidx cmax) 0 (1+ cidx)))
	(vector-set! plane x cidx)

	;; move
	;; x = v + h*width for a pixel at (h,v)
	(set! x
		(cond
			((= dir 0) (1+ x))
			((= dir 1) (+ x width))
			((= dir 2) (1- x))
			((= dir 3) (- x width))))
		
	(when (or (< x 0) (>= x xmax)) (set! iter -666)) ;; out of bounds
	(set! iter (1- iter)))
	iter)
	
;; a color table of 16 colors
(define colors
   (list 0 (rgb 1 1 1) (rgb 1 0 0) (rgb 0 1 0) (rgb 0 0 1) (rgb 1 1 0) (rgb 1 0 1) (rgb 0 1 1)))
(define colors (list->vector (append colors colors)))

;; transform color index into rgb color, using colors table.
(define (colorize plane xmax)
	(for ((x xmax))
		(vector-set! plane x (vector-ref colors (vector-ref plane x))))
	(vector->pixels plane)
	xmax )
	
;; ant's patterns
(define turns #(#t #t #f #f #f #t #f #f #f #t #t #t))   ;; RRLLLRLLLRRR
;;(define turns #(#t #t #f #f #f #t #t #f)) ; RRLLLRRL
;;(define turns #(#t #f)) ; RL : basic ant

(define  (ant (iter 100000))
	(plot-clear)
	(define width (first (pixels-dim))) ;; plane dimensions
	(define height (rest (pixels-dim)))
	(define plane (pixels->uint32-vector))
	(define x (+ (quotient width 2) (* width (quotient height 2)))) ;; middle of plane
	(define xmax (* width height))
	
	(move iter  x 0 plane turns (1- (vector-length turns)) width xmax)
	(colorize plane xmax))

(ant) ;; run
