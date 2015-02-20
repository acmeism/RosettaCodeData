(defconstant +2x2-identity+ '(1 0 0 1))
(defconstant +fib-seed+ '(1 1 1 0))

(defun multiply-2x2 (matrix-1 matrix-2)
  (let* ((a (first matrix-1)) (b (second matrix-1)) (c (third matrix-1)) (d (fourth matrix-1))
	 (e (first matrix-2)) (f (second matrix-2)) (g (third matrix-2)) (h (fourth matrix-2))
	 (ae (* a e)) (bg (* b g)) (af (* a f)) (bh (* b h))
	 (ce (* c e)) (dg (* d g)) (cf (* c f)) (dh (* d h)))
    (list (+ ae bg) (+ af bh) (+ ce dg) (+ cf dh))))

(defun square-2x2 (matrix)
  (multiply-2x2 matrix matrix))

(defun 2x2-exponentiation (matrix n)
  (cond ((zerop n) +2x2-identity+)
	((eql n 1) matrix)
	((evenp n) (square-2x2 (2x2-exponentiation matrix (/ n 2))))
	(t (multiply-2x2 (square-2x2 (2x2-exponentiation matrix (/ (1- n) 2))) matrix))))

(defun fib (n)
  (car (2x2-exponentiation +fib-seed+ (1- n))))
