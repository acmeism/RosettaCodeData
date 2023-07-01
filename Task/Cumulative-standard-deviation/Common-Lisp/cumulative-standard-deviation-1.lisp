(defun running-stddev ()
  (let ((sum 0) (sq 0) (n 0))
    (lambda (x)
      (incf sum x) (incf sq (* x x)) (incf n)
      (/ (sqrt (- (* n sq) (* sum sum))) n))))

CL-USER> (loop with f = (running-stddev) for i in '(2 4 4 4 5 5 7 9) do
	(format t "~a ~a~%" i (funcall f i)))
NIL
2 0.0
4 1.0
4 0.94280905
4 0.8660254
5 0.97979593
5 1.0
7 1.3997085
9 2.0
