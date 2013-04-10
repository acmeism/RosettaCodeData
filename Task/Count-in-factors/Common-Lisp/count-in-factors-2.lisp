(defun factors (n)
  (loop with res for x from 2 to (isqrt n) do
	(loop while (zerop (rem n x)) do
	      (setf n (/ n x))
	      (push x res))
	finally (return (if (> n 1) (cons n res) res))))

(loop for n from 1 do
      (format t "~a: ~{~a~^ × ~}~%" n (reverse (factors n))))
