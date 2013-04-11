(defun move (n from to via)
  (cond ((= n 1)
         (print (format "Move from %S to %S" from to)))
        (t
	 (progn
	   (move (- n 1) from via to)
	   (print (format "Move from %S to %S" from to))
	   (move (- n 1) via to from)))))
