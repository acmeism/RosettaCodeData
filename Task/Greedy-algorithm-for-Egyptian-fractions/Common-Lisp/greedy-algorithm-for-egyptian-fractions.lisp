(defun egyption-fractions (x y &optional acc)
  (let* ((a (/ x y)))
    (cond
     ((> (numerator a) (denominator a))
      (multiple-value-bind (q r) (floor x y)
	(if (zerop r)
	    (cons q acc)
	    (egyption-fractions r y (cons q acc)))))
     ((= (numerator a) 1) (reverse (cons a acc)))
     (t (let ((b (ceiling y x)))
	  (egyption-fractions (mod (- y) x) (* y b) (cons (/ b) acc)))))))

(defun test (n fn)
  (car (sort (loop for i from 1 to n append
		   (loop for j from 2 to n collect
			 (cons (/ i j) (funcall fn (egyption-fractions i j)))))
	     #'>
	     :key #'cdr)))
