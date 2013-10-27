(defun n-queens (n m)
  (if (= n 1)
    (loop for x from 1 to m collect (list x))
    (loop for sol in (n-queens (1- n) m) nconc
	  (loop for col from 1 to m when
		(loop for row from 0 to (length sol) for c in sol
		      always (and (/= col c)
				  (/= (abs (- c col)) (1+ row)))
		      finally (return (cons col sol)))
		collect it))))

(defun show-solution (b n)
  (loop for i in b do
	(format t "~{~A~^~}~%"
		(loop for x from 1 to n collect (if (= x i) "Q " ". "))))
  (terpri))

(let ((i 0) (n 8))
  (mapc #'(lambda (s)
	    (format t "Solution ~a:~%" (incf i))
	    (show-solution s n))
	(n-queens n n)))
