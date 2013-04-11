(defun hamming (n)
  (let ((fac '(2 3 5))
	(idx (make-array 3 :initial-element 0))
	(h (make-array (1+ n)
		       :initial-element 1
		       :element-type 'integer)))
    (loop for i from 1 to n
	  with e with x = '(1 1 1) do
	  (setf e (setf (aref h i) (apply #'min x))
		x (loop for y in x
			for f in fac
			for j from 0
			collect (if (= e y) (* f (aref h (incf (aref idx j)))) y))))
    (aref h n)))

(loop for i from 1 to 20 do
      (format t "~2d: ~d~%" i (hamming i)))

(loop for i in '(1691 1000000) do
      (format t "~d: ~d~%" i (hamming i)))
