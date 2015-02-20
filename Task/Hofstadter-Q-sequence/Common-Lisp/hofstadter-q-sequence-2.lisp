(let ((cc (make-array 3 :element-type 'integer
		        :initial-element 1
			:adjustable t
			:fill-pointer 3)))
      (defun q (n)
	(when (>= n (length cc))
	  (loop for i from (length cc) below n do (q i))
	  (vector-push-extend
	    (+ (aref cc (- n (aref cc (- n 1))))
	       (aref cc (- n (aref cc (- n 2)))))
	    cc))
	(aref cc n)))
