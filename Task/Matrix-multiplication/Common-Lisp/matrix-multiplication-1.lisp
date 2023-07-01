(defun matrix-multiply (a b)
  (flet ((col (mat i) (mapcar #'(lambda (row) (elt row i)) mat))
         (row (mat i) (elt mat i)))
    (loop for row from 0 below (length a)
          collect (loop for col from 0 below (length (row b 0))
                        collect (apply #'+ (mapcar #'* (row a row) (col b col)))))))

;; example use:
(matrix-multiply '((1 2) (3 4)) '((-3 -8 3) (-2 1 4)))
