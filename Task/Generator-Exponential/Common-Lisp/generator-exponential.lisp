(defun take (seq &optional (n 1))
  (values-list (loop repeat n collect (funcall seq))))

(defun power-seq (n)
  (let ((x 0))
    (lambda () (expt (incf x) n))))

(defun filter-seq (s1 s2) ;; remove s2 from s1
  (let ((x1 (take s1)) (x2 (take s2)))
    (lambda ()
      (tagbody g
	(if (= x1 x2)
	     (progn (setf x1 (take s1) x2 (take s2)) (go g)))
	(if (> x1 x2)
	     (progn (setf x2 (take s2)) (go g))))

      (prog1 x1 (setf x1 (take s1))))))

(let ((2not3 (filter-seq (power-seq 2) (power-seq 3))))
  (take 2not3 20) ;; drop 20
  (princ (multiple-value-list (take 2not3 10))))
