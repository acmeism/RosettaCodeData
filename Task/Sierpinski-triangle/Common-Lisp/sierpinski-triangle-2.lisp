(defun sierpinski (n)
  (if (= n 0) '("*")
      (nconc (mapcar (lambda (e) (format nil "~A~A~0@*~A" (make-string (expt 2 (1- n)) :initial-element #\ ) e)) (sierpinski (1- n)))
	     (mapcar (lambda (e) (format nil "~A ~A" e e)) (sierpinski (1- n))))))

(mapc #'print (sierpinski 4))
