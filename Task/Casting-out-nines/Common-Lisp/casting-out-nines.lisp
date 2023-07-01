;;A macro was used to ensure that the filter is inlined.
;;Larry Hignight.  Last updated on 7/3/2012.
(defmacro kaprekar-number-filter (n &optional (base 10))
  `(= (mod ,n (1- ,base)) (mod (* ,n ,n) (1- ,base))))

(defun test (&key (start 1) (stop 10000) (base 10) (collect t))
  (let ((count 0)
	(nums))
    (loop for i from start to stop do
	  (when (kaprekar-number-filter i base)
	    (if collect (push i nums))
	    (incf count)))
    (format t "~d potential Kaprekar numbers remain (~~~$% filtered out).~%"
	    count (* (/ (- stop count) stop) 100))
    (if collect (reverse nums))))
