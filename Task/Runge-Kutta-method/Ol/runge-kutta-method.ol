(import (scheme core))


(define (func x y)
	(inexact (* x (sqrt y)) )
)

(define (exact-sol x)
	(inexact (* (/ 1.0 16.0) (expt (+ (expt x 2) 4) 2) ))
)

(define steps 101)


(define h 0.1)
(define x0 0.0)
(define y0 1.0)


(define factor (inexact (/ 1.0 6.0)))

(define (rk x y step sol)
	(let*
	(
		(dy1 (* h (func x y)))
		(dy2 (* h (func (+ x (* 0.5 h )) (+ y (* 0.5 dy1 )) )))
		(dy3 (* h (func (+ x (* 0.5 h )) (+ y (* 0.5 dy2 )) )))
		(dy4 (* h (func (+ h x) (+ y dy3) )))
		(ynone (inexact (+ y (* factor (apply + (list dy1 (* 2 dy2) (* 2 dy3) dy4 ) ) )) ))
		(sol (reverse (cons ynone sol)))
		(step (+ 1 step))
	)
		(cond
			(
			(equal? 0 (modulo  step 10))
				(display "solution: ")
				(display ynone)			
				(display " exact: ")
				(display (exact-sol (+ x h)))
				(display " error: ")
				(display (abs (- y (exact-sol x))))
				(newline)
			)
			
		)
		(if (< step steps)
			(rk (+ x h) ynone step sol )
			(reverse (cons y0 (reverse sol)))
		)
	
	)
)

(display "start: ")
(display y0)
(newline)
(define solution (rk x0 y0 0 '()))
