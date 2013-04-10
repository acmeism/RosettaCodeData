(defun count-change (amount coins)
  (let ((cache (make-array (list (1+ amount) (length coins))
			   :initial-element nil)))
    (macrolet ((h () `(aref cache n l)))
      (labels
	((recur (n coins &optional (l (1- (length coins))))
		(cond ((< l 0) 0)
		      ((< n 0) 0)
		      ((= n 0) 1)
		      (t (if (h) (h) ; cached
			   (setf (h) ; or not
				 (+ (recur (- n (car coins)) coins l)
				    (recur n (cdr coins) (1- l)))))))))

	;; enable next line if recursions too deep
	;(loop for i from 0 below amount do (recur i coins))
	(recur amount coins)))))

; (compile 'count-change) ; for CLISP

(print (count-change 100 '(25 10 5 1)))		   ; = 242
(print (count-change 100000 '(100 50 25 10 5 1)))  ; = 13398445413854501
(terpri)
