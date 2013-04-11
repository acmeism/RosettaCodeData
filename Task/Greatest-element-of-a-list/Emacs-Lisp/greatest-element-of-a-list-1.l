(defun max (first-arg &rest more-args)
  (if more-args
      (let ((max-rest (apply 'max more-args)))
	(if (> first-arg max-rest)
	    first-arg
	  max-rest))
    first-arg))
