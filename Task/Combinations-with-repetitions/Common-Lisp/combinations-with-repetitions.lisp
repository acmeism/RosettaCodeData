(defun combinations (xs k)
  (let ((x (car xs)))
    (cond
     ((null xs) nil)
     ((= k 1) (mapcar #'list xs))
     (t (append (mapcar (lambda (ys) (cons x ys))
			(combinations xs (1- k)))
		(combinations (cdr xs) k))))))
