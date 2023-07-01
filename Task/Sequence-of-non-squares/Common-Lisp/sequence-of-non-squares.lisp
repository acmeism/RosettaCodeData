(defun non-square-sequence ()
  (flet ((non-square (n)
	   "Compute the N-th number of the non-square sequence"
	   (+ n (floor (+ 1/2 (sqrt n)))))
	 (squarep (n)
	   "Tests, whether N is a square"
	   (let ((r (floor (sqrt n))))
	     (= (* r r) n))))
    (loop
       :for n :upfrom 1 :to 22
       :do (format t "~2D -> ~D~%" n (non-square n)))
    (loop
       :for n :upfrom 1 :to 1000000
       :when (squarep (non-square n))
       :do (format t "Found a square: ~D -> ~D~%"
		   n (non-square n)))))
