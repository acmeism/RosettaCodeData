(defun permute
  (('())
    '(()))
  ((l)
    (lc ((<- x l)
         (<- y (permute (-- l `(,x)))))
        (cons x y))))
