CL-USER> (defparameter alist
	   (loop for i from 1 to 10
	      collect (cons i (let ((i i))
				(lambda () (* i i))))))
ALIST
CL-USER> (funcall (cdr (assoc 2 alist)))
4
CL-USER> (funcall (cdr (assoc 8 alist)))
64
