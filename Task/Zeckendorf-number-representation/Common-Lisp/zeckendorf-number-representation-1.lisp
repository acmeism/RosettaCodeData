(defun zeckendorf (n)
   "returns zeckendorf integer of n (see OEIS A003714)"
   (let ((fib '(2 1)))
	;; extend Fibonacci sequence long enough
	(loop while (<= (car fib) n) do
	      (push (+ (car fib) (cadr fib)) fib))
	(loop with r = 0 for f in fib do
	      (setf r (* 2 r))
	      (when (>= n f) (setf n (- n f))
			     (incf r))
	      finally (return r))))

;;; task requirement
(loop for i from 0 to 20 do
      (format t "~2D: ~2R~%" i (zeckendorf i)))
