(defun matrix* (matrix-1 matrix-2)
  (list-comp
    ((<- a matrix-1))
    (list-comp
      ((<- b (transpose matrix-2)))
      (lists:foldl #'+/2 0
                   (lists:zipwith #'*/2 a b)))))
