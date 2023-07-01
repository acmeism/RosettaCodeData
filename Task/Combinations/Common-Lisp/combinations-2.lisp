(defun comb (m list fn)
  (labels ((comb1 (l c m)
		  (when (>= (length l) m)
		    (if (zerop m) (return-from comb1 (funcall fn c)))
		    (comb1 (cdr l) c m)
		    (comb1 (cdr l) (cons (first l) c) (1- m)))))
    (comb1 list nil m)))

(comb 3 '(0 1 2 3 4 5) #'print)
