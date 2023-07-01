(defun matrix-multiply (matrix1 matrix2)
 (mapcar
  (lambda (row)
   (apply #'mapcar
    (lambda (&rest column)
     (apply #'+ (mapcar #'* row column))) matrix2)) matrix1))
