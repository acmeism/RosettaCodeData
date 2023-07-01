(defun hailstone (n)
  (cond ((= n 1) '(1))
	((evenp n) (cons n (hailstone (/ n 2))))
	(t (cons n (hailstone (+ (* 3 n) 1))))))

(defun longest (n)
  (let ((k 0) (l 0))
    (loop for i from 1 below n do
	 (let ((len (length (hailstone i))))
	   (when (> len l) (setq l len k i)))
	 finally (format t "Longest hailstone sequence under ~A for ~A, having length ~A." n k l))))
