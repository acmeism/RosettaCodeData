(defun parse-roman (r)
  (loop for l on (map 'list (lambda (c)
			      (getf '(#\I 1 #\V 5 #\X 10 #\L 50 #\C 100 #\D 500 #\M 1000) c))
		      (string-upcase r))
     sum (let ((a (first l)) (b (second l)))
	   (if (and b (< a b)) (- a) a))))
;; test code
(dolist (r '("MCMXC" "MDCLXVI" "MMVIII"))
  (format t "~a: ~d~%" r (parse-roman r)))
