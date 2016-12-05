(defun dot-product (a b)
  (: lists foldl #'+/2 0
    (: lists zipwith #'*/2 a b)))
