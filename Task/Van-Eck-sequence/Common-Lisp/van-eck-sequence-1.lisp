;;Tested using CLISP

(defun VanEck (x) (reverse (VanEckh x 0 0 '(0))))

(defun VanEckh (final index curr lst)
	(if (eq index final)
		lst
		(VanEckh final (+ index 1) (howfar curr lst) (cons curr lst))))

(defun howfar (x lst) (howfarh x lst 0))

(defun howfarh (x lst runningtotal)
	(cond
		((null lst) 0)
		((eq x (car lst)) (+ runningtotal 1))
		(t (howfarh x (cdr lst) (+ runningtotal 1)))))

(format t "The first 10 elements are ~a~%" (VanEck 9))
(format t "The 990-1000th elements are ~a~%" (nthcdr 990 (VanEck 999)))
