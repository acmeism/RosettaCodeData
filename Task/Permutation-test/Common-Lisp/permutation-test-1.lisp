(defun perm-test (s1 s2)
  (let ((more 0) (leq 0)
	(all-data (append s1 s2))
	(thresh (apply #'+ s1)))
    (labels
      ((recur (data sum need avail)
	      (cond ((zerop need)   (if (>= sum thresh)
				      (incf more)
				      (incf leq)))
		    ((>= avail need)
		       (recur (cdr data) sum need (1- avail))
		       (recur (cdr data) (+ sum (car data)) (1- need) (1- avail))))))

      (recur all-data 0 (length s1) (length all-data))
      (cons more leq))))

(let* ((a (perm-test '(68 41 10 49 16 65 32 92 28 98)
		     '(85 88 75 66 25 29 83 39 97)))
       (x (car a))
       (y (cdr a))
       (s (+ x y)))
  (format t "<=: ~a ~6f%~% >: ~a ~6f%~%"
	  x (* 100e0 (/ x s))
	  y (* 100e0 (/ y s))))
