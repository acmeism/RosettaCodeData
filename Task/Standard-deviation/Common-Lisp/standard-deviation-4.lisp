(defun running-stddev ()
  (let ((sum 0) (sq 0) (n 0))
    (lambda (x)
      (incf sum x) (incf sq (* x x)) (incf n)
      (/ (sqrt (- (* n sq) (* sum sum))) n))))

(loop with f = (running-stddev) for i in '(2 4 4 4 5 5 7 9) do
	(format t "~a ~a~%" i (funcall f i)))
