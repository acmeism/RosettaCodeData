(defun levenshtein (a b)
  (let* ((la  (length a))
	 (lb  (length b))
	 (rec (make-array (list (1+ la) (1+ lb)) :initial-element nil)))

    (defun leven (x y)
      (cond
	((zerop x) y)
	((zerop y) x)
	((aref rec x y) (aref rec x y))
	(t (setf (aref rec x y)
		 (+ (if (char= (char a (- la x)) (char b (- lb y))) 0 1)
		    (min (leven (1- x) y)
			 (leven x (1- y))
			 (leven (1- x) (1- y))))))))
    (leven la lb)))

(print (levenshtein "rosettacode" "raisethysword"))
