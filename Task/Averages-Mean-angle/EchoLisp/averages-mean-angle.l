(define-syntax-rule  (deg->radian deg) (* deg 1/180 PI))
(define-syntax-rule  (radian->deg rad) (* 180 (/ PI) rad))

(define (mean-angles angles)
	(radian->deg
          (angle
	    (for/sum ((a angles)) (make-polar 1 (deg->radian a))))))

(mean-angles '( 350 10))
    → -0
(mean-angles '[90 180 270 360])
    → -90
(mean-angles '[10 20 30])
    → 20
