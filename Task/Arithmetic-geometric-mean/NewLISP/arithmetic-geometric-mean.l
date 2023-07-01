(define (a-next a g) (mul 0.5 (add a g)))

(define (g-next a g) (sqrt (mul a g)))

(define (amg a g tolerance)
	(if (<= (sub a g) tolerance)
		a
		(amg (a-next a g) (g-next a g) tolerance)
	)
)

(define quadrillionth 0.000000000000001)

(define root-reciprocal-2 (div 1.0 (sqrt 2.0)))

(println
	"To the nearest one-quadrillionth, "
	"the arithmetic-geometric mean of "
	"1 and the reciprocal of the square root of 2 is "
	(amg 1.0 root-reciprocal-2 quadrillionth)
)
