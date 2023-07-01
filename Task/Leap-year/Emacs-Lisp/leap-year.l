(defun leap-year-p (year)
  (apply (lambda (a b c) (or a (and (not b) c)))
	 (mapcar (lambda (n) (zerop (mod year n)))
		 '(400 100 4))))
