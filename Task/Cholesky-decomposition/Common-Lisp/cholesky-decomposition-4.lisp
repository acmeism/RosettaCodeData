;; case of matrix stored as a list of lists (inner lists are rows of matrix)
;; as above, returns the Cholesky decomposition matrix of a square positive-definite, symmetric matrix
(defun cholesky (m)
  (let ((l (list (list (sqrt (caar m))))) x (j 0) i)
    (dolist (cm (cdr m) (mapcar #'(lambda (x) (nconc x (make-list (- (length m) (length x)) :initial-element 0))) l))
      (setq x (list (/ (car cm) (caar l))) i 0)
      (dolist (cl (cdr l))
        (setf (cdr (last x)) (list (/ (- (elt cm (incf i)) (*v x cl)) (car (last cl))))))
      (setf (cdr (last l)) (list (nconc x (list (sqrt (- (elt cm (incf j)) (*v x x))))))))))
;; where *v is the scalar product defined as
(defun *v (v1 v2) (reduce #'+ (mapcar #'* v1 v2)))
