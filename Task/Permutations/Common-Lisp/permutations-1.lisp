(defun permute (list)
  (if list
    (mapcan #'(lambda (x)
		(mapcar #'(lambda (y) (cons x y))
			(permute (remove x list))))
	    list)
    '(()))) ; else

(print (permute '(A B Z)))
